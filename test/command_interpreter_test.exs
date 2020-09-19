defmodule Termpaint.UnsupportedCommandError do
  defexception ~w{message}a
end

defmodule Termpaint.CommandInterpreter do
  alias Termpaint.UnsupportedCommandError

  def parse(string) when is_binary(string) do
    case String.trim(string) do
      "" -> %UnsupportedCommandError{}
    end
  end

  def parse(_) do
    %UnsupportedCommandError{}
  end
end

defmodule Termpaint.CommandInterpreterTest do
  use ExUnit.Case, async: true

  alias Termpaint.{CommandInterpreter, UnsupportedCommandError}

  test "nil string" do
    assert %UnsupportedCommandError{} == CommandInterpreter.parse(nil)
  end

  test "empty string" do
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("")
  end

  test "blank string" do
    assert %UnsupportedCommandError{} == CommandInterpreter.parse("\t        \r \n  \t\t  ")
  end
end
