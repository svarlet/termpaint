defmodule Termpaint.UnsupportedCommandError do
  defexception ~w{message}a
end

defmodule Termpaint.CommandInterpreter do
  alias Termpaint.UnsupportedCommandError

  def parse(string) do
    case string do
      nil -> %UnsupportedCommandError{}
      "" -> %UnsupportedCommandError{}
    end
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
end
