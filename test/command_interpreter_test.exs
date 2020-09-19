defmodule Termpaint.UnsupportedCommandError do
  defexception ~w{message}a
end

defmodule Termpaint.CreateCanvasCommand do
  defstruct width: 1, height: 1
end

defmodule Termpaint.DrawLineCommand do
  defstruct from: {0, 0}, to: {0, 0}
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
end

defmodule Termpaint.Parser do
  import NimbleParsec

  alias Termpaint.Parser.Helpers

  canvas_command =
    string("C")
    |> ignore(string(" "))
    |> concat(Helpers.dimensions())

  draw_line_command =
    string("L")
    |> ignore(string(" "))
    |> concat(Helpers.coords())
    |> ignore(string(" "))
    |> concat(Helpers.coords())

  defparsec(:canvas_command, canvas_command)
  defparsec(:draw_line_command, draw_line_command)
end

defmodule Termpaint.CommandInterpreter do
  alias Termpaint.{UnsupportedCommandError, CreateCanvasCommand, DrawLineCommand, Parser}

  defp sanitize(text_command) do
    text_command
    |> String.trim()
    |> String.replace(~r/[[:space:]]+/, " ")
  end

  def parse(string) when is_binary(string) do
    text_command = sanitize(string)

    case text_command do
      "" ->
        %UnsupportedCommandError{}

      "C" <> _args ->
        case Parser.canvas_command(text_command) do
          {:ok, ["C", width, height], _, _, _, _} ->
            %CreateCanvasCommand{width: width, height: height}

          _error ->
            %UnsupportedCommandError{}
        end

      "L" <> _args ->
        case Parser.draw_line_command(text_command) do
          {:ok, ["L", x_from, y_from, x_to, y_to], _, _, _, _} ->
            %DrawLineCommand{from: {x_from, y_from}, to: {x_to, y_to}}
          _error ->
            %UnsupportedCommandError{}
        end
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
    DrawLineCommand
  }

  test "nil string" do
    assert %UnsupportedCommandError{} == CommandInterpreter.parse(nil)
  end

  test "empty string" do
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("")
  end

  test "blank string" do
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("\t        \r \n  \t\t  ")
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
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("C a 10")
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("C 3 ?")
  end

  test "create a canvas when width or height is a negative integer" do
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("C -1 20")
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("C 10 -4")
  end

  test "draw a line when either origin or destination coords have a negative position" do
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("L -1 2 3 4")
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("L 1 -2 3 4")
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("L 1 2 -3 4")
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("L 1 2 3 -4")
  end

  test "draw a line from (2,4) to (100, 5)" do
    assert %DrawLineCommand{from: {2, 4}, to: {100, 5}} == CommandInterpreter.parse("L 2 4 100 5")
  end

  test "draw a line from coordinates not defined by nunbers" do
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("L a 2 3 4")
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("L 1 ? 3 4")
  end
end
