defmodule TermpaintTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias Termpaint.{Canvas, CommandInterpreter, Printer}

  test "create a 4x4 canvas" do
    state = CommandInterpreter.process_command(nil, "C 4 4")

    assert capture_io(fn -> Printer.print_canvas(state) end) ==
             """
             ------
             |    |
             |    |
             |    |
             |    |
             ------
             """
  end

  test "draw a line from (1,1) to (3,3) in a 3x3 canvas" do
    state =
      Canvas.new(3, 3)
      |> CommandInterpreter.process_command("L 1 1 3 3")

    assert capture_io(fn -> Printer.print_canvas(state) end) ==
             """
             -----
             |xxx|
             |  x|
             |  x|
             -----
             """
  end

  test "draw a rectangle from (2,2) to (4,4) in a 5x5 canvas" do
    state =
      Canvas.new(5, 5)
      |> CommandInterpreter.process_command("R 2 2 4 4")

    assert capture_io(fn -> Printer.print_canvas(state) end) ==
             """
             -------
             |     |
             | xxx |
             | x x |
             | xxx |
             |     |
             -------
             """
  end

  test "bucket fill a complex area with the $ symbol" do
    state =
      Canvas.new(5, 5)
      |> Canvas.draw_rectangle(1, 1, 3, 3)
      |> Canvas.draw_line(5, 5, 4, 5)
      |> CommandInterpreter.process_command("B 1 5 $")

    assert capture_io(fn -> Printer.print_canvas(state) end) ==
             """
             -------
             |xxx$$|
             |x x$$|
             |xxx$$|
             |$$$$$|
             |$$$xx|
             -------
             """
  end
end
