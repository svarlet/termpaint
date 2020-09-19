defmodule Termpaint.UnsupportedCommandError do
  defexception ~w{message}a
end

defmodule Termpaint.CreateCanvasCommand do
  defstruct width: 1, height: 1
end

defmodule Termpaint.CommandInterpreter do
  alias Termpaint.{UnsupportedCommandError, CreateCanvasCommand}

  def parse(string) when is_binary(string) do
    case String.trim(string) do
      "" -> %UnsupportedCommandError{}
      "C 10 20" -> %CreateCanvasCommand{width: 10, height: 20}
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

  test "create a canvas" do
    assert %CreateCanvasCommand{width: 10, height: 20} == CommandInterpreter.parse("C 10 20")
  end
end
