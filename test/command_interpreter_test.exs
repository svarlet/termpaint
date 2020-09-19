defmodule Termpaint.UnsupportedCommandError do
  defexception ~w{message}a
end

defmodule Termpaint.CreateCanvasCommand do
  defstruct width: 1, height: 1
end

defmodule Termpaint.DrawLineCommand do
  defstruct from: {1, 1}, to: {1, 1}
end

defmodule Termpaint.DrawRectangleCommand do
  defstruct from: {1, 1}, to: {1, 1}
end

defmodule Termpaint.BucketFillCommand do
  defstruct position: {1, 1}, ink: "."
end

defmodule Termpaint.Parser.Helpers do
  import NimbleParsec

  def positive_int() do
    integer(min: 1)
  end

  def dimensions() do
    positive_int()
    |> ignore(string: " ")
    |> concat(positive_int())
  end

  def coords() do
    positive_int()
    |> ignore(string: " ")
    |> concat(positive_int())
  end

  def canvas_command() do
    string("C")
    |> ignore(string(" "))
    |> concat(dimensions())
    |> eos()
  end

  def draw_line_command() do
    string("L")
    |> ignore(string(" "))
    |> concat(coords())
    |> ignore(string(" "))
    |> concat(coords())
    |> eos()
  end

  def draw_rectangle_command() do
    string("R")
    |> ignore(string(" "))
    |> concat(coords())
    |> ignore(string(" "))
    |> concat(coords())
    |> eos()
  end

  def bucket_fill_command() do
    string("B")
    |> ignore(string(" "))
    |> concat(coords())
    |> ignore(string(" "))
    |> utf8_string([], 1)
    |> eos()
  end
end

defmodule Termpaint.Parser do
  import NimbleParsec
  import Termpaint.Parser.Helpers

  defparsec(
    :to_supported_command,
    choice([
      canvas_command(),
      draw_line_command(),
      draw_rectangle_command(),
      bucket_fill_command()
    ])
  )
end

defmodule Termpaint.CommandInterpreter do
  alias Termpaint.{
    UnsupportedCommandError,
    CreateCanvasCommand,
    DrawLineCommand,
    DrawRectangleCommand,
    BucketFillCommand,
    Parser
  }

  defp sanitize(text_command) do
    text_command
    |> String.trim()
    |> String.replace(~r/[[:space:]]+/, " ")
  end

  def parse(string) when is_binary(string) do
    text_command = sanitize(string)

    case Parser.to_supported_command(text_command) do
      {:ok, tokens, _, _, _, _} ->
        case tokens do
          ["C", width, height] ->
            %CreateCanvasCommand{width: width, height: height}

          ["L", x_from, y_from, x_to, y_to] ->
            %DrawLineCommand{from: {x_from, y_from}, to: {x_to, y_to}}

          ["R", x_from, y_from, x_to, y_to] ->
            %DrawRectangleCommand{from: {x_from, y_from}, to: {x_to, y_to}}

          ["B", x, y, ink] ->
            %BucketFillCommand{position: {x, y}, ink: ink}
        end

      {:error, _, _, _, _, _} ->
        %UnsupportedCommandError{}
    end
  end

  def parse(_) do
    %UnsupportedCommandError{}
  end
end

defmodule Termpaint.CommandInterpreterTest do
  use ExUnit.Case, async: true

  alias Termpaint.{
    CommandInterpreter,
    UnsupportedCommandError,
    CreateCanvasCommand,
    DrawLineCommand,
    DrawRectangleCommand,
    BucketFillCommand
  }

  test "nil string" do
    rejects_text_command(nil)
  end

  test "empty string" do
    rejects_text_command("")
  end

  test "blank string" do
    rejects_text_command("\t        \r \n  \t\t  ")
  end

  test "create a 10x20 canvas" do
    assert %CreateCanvasCommand{width: 10, height: 20} == CommandInterpreter.parse("C 10 20")
  end

  test "create a canvas command with superfluous whitespace chars" do
    assert %CreateCanvasCommand{width: 10, height: 20} ==
             CommandInterpreter.parse("  C   \t 10 \r \n  20 \n \t")
  end

  test "create a 5x5 canvas" do
    assert %CreateCanvasCommand{width: 5, height: 5} == CommandInterpreter.parse("C 5 5")
  end

  test "create a canvas when width or height is not a number" do
    rejects_text_command("C a 10")
    rejects_text_command("C 3 ?")
  end

  test "create a canvas when width or height is a negative integer" do
    rejects_text_command("C -1 20")
    rejects_text_command("C 10 -4")
  end

  test "draw a line when either origin or destination coords have a negative position" do
    rejects_text_command("L -1 2 3 4")
    rejects_text_command("L 1 -2 3 4")
    rejects_text_command("L 1 2 -3 4")
    rejects_text_command("L 1 2 3 -4")
  end

  test "draw a line from (2,4) to (100, 5)" do
    assert %DrawLineCommand{from: {2, 4}, to: {100, 5}} == CommandInterpreter.parse("L 2 4 100 5")
  end

  test "draw a line from coordinates not defined by nunbers" do
    rejects_text_command("L a 2 3 4")
    rejects_text_command("L 1 ? 3 4")
  end

  test "draw a line to coordinates not defined by nunbers" do
    rejects_text_command("L 1 2 k 4")
    rejects_text_command("L 1 2 3 -")
  end

  test "draw a rectangle from (2,3) to (27,45)" do
    assert %DrawRectangleCommand{from: {2, 3}, to: {27, 45}} ==
             CommandInterpreter.parse("R 2 3 27 45")
  end

  test "draw a rectangle with non numerical coordinates" do
    rejects_text_command("R a 1 2 3")
    rejects_text_command("R 1 b 2 3")
    rejects_text_command("R 1 1 c 3")
    rejects_text_command("R 1 1 2 d")
  end

  test "bucket fill requires 2 coords and 1 ascii character" do
    assert %BucketFillCommand{position: {3, 4}, ink: "+"} == CommandInterpreter.parse("B 3 4 +")
  end

  test "bucket fill's ink cannot be 2 characters or more" do
    rejects_text_command("B 1 18 yo")
    rejects_text_command("B 1 18 foo")
  end

  test "commands don't support extra arguments" do
    rejects_text_command("C 1 2 extra")
    rejects_text_command("L 1 18 2 3 extra")
    rejects_text_command("R 3 4 19 2993 extra")
    rejects_text_command("B 1 18 ? extra")
  end

  defp rejects_text_command(text_command) do
    assert %UnsupportedCommandError{} == CommandInterpreter.parse(text_command)
  end
end
