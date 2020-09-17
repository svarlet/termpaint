defmodule TermpaintTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias Termpaint.Canvas

  test "create a 4x4 canvas" do
    state = nil

    assert capture_io(fn -> Termpaint.process_command(state, "C 4 4") end) ==
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
    state = Canvas.new(3, 3)

    assert capture_io(fn -> Termpaint.process_command(state, "L 1 1 3 3") end) ==
             """
             -----
             |xxx|
             |  x|
             |  x|
             -----
             """
  end

  test "draw a rectangle from (2,2) to (4,4) in a 5x5 canvas" do
    state = Canvas.new(5, 5)

    assert capture_io(fn -> Termpaint.process_command(state, "R 2 2 4 4") end) ==
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
end
