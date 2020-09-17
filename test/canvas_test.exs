defmodule Termpaint.CanvasTest do
  use ExUnit.Case, async: true

  alias Termpaint.Canvas

  test "a new 1x1 canvas" do
    assert %Canvas{width: 1, height: 1} == Canvas.new(1, 1)
  end

  test "a new 2x7 canvas" do
    assert %Canvas{width: 2, height: 7} == Canvas.new(2, 7)
  end

  test "a (1, 1) to (1, 1) line" do
    canvas =
      Canvas.new(1, 1)
      |> Canvas.draw_line({1, 1, 1, 1})
    assert canvas.coords == %{{1, 1} => "x"}
  end
end
