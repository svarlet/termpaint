defmodule Termpaint.CommandInterpreterTest do
  use ExUnit.Case, async: true

  alias Termpaint.{
    CommandInterpreter,
    UnsupportedCommandError,
    CreateCanvasCommand,
    DrawLineCommand,
    DrawRectangleCommand,
    BucketFillCommand,
    QuitCommand
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
    rejects_text_command("Q extra")
  end

  test "quit command" do
    assert %QuitCommand{} == CommandInterpreter.parse("Q")
  end

  defp rejects_text_command(text_command) do
    assert %UnsupportedCommandError{} == CommandInterpreter.parse(text_command)
  end
end
