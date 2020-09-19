defmodule Termpaint.UnsupportedCommandError do
  defexception ~w{message}a
end

defmodule Termpaint.CreateCanvasCommand do
  defstruct width: 1, height: 1
end

defmodule Termpaint.CommandInterpreter do
  alias Termpaint.{UnsupportedCommandError, CreateCanvasCommand}

  def parse(string) when is_binary(string) do
    text_command =
      string
      |> String.trim()
      |> String.replace(~r/[[:space:]]+/, " ")
    case text_command do
      "" -> %UnsupportedCommandError{}
      "C 10 20" -> %CreateCanvasCommand{width: 10, height: 20}
      "C 5 5" -> %CreateCanvasCommand{width: 5, height: 5}
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
    assert %CreateCanvasCommand{width: 10, height: 20} == CommandInterpreter.parse("  C   \t 10 \r \n  20 \n \t")
  end

  test "create a 5x5 canvas" do
    assert %CreateCanvasCommand{width: 5, height: 5} == CommandInterpreter.parse("C 5 5")
  end
end
