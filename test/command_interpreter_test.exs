defmodule Termpaint.UnsupportedCommandError do
  defexception ~w{message}a
end

defmodule Termpaint.CreateCanvasCommand do
  defstruct width: 1, height: 1
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
end

defmodule Termpaint.Parser do
  import NimbleParsec

  alias Termpaint.Parser.Helpers

  canvas_command =
    string("C")
    |> ignore(string(" "))
    |> concat(Helpers.dimensions())

  defparsec(:canvas_command, canvas_command)
end

defmodule Termpaint.CommandInterpreter do
  alias Termpaint.{UnsupportedCommandError, CreateCanvasCommand, Parser}

  defp sanitize(text_command) do
    text_command
    |> String.trim()
    |> String.replace(~r/[[:space:]]+/, " ")
  end

  def parse(string) when is_binary(string) do
    text_command = sanitize(string)

    case text_command do
      "" -> %UnsupportedCommandError{}
      "C" <> _args ->
        case Parser.canvas_command(text_command) do
          {:ok, ["C", width, height], _, _, _, _} -> %CreateCanvasCommand{width: width, height: height}
          _error -> %UnsupportedCommandError{}
        end
    end
  end

  def parse(_) do
    %UnsupportedCommandError{}
  end
end

defmodule Termpaint.CommandInterpreterTest do
  use ExUnit.Case, async: true

  alias Termpaint.{CommandInterpreter, UnsupportedCommandError, CreateCanvasCommand}

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
end
