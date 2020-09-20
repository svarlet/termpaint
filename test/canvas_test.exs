defmodule CanvasTest do
  use ExUnit.Case, async: true

  alias Termpaint.Canvas

  describe "within?" do
    test "returns false when the X coord of a point stands outside the canvas" do
      canvas = %Canvas{width: 3, height: 3}

      point = {0, 2}
      refute Canvas.within?(canvas, point)

      point = {4, 3}
      refute Canvas.within?(canvas, point)
    end

    test "returns false when the Y coord of a point stands outside the canvas" do
      canvas = %Canvas{width: 3, height: 3}

      point = {1, 0}
      refute Canvas.within?(canvas, point)

      point = {1, 4}
      refute Canvas.within?(canvas, point)
    end

    test "returns true when a point stands within the canvas" do
      canvas = %Canvas{width: 10, height: 10}
      point = {5, 5}
      assert Canvas.within?(canvas, point)
    end
  end

  describe "mark" do
    test "marks 1 coordinate with the specified ink character" do
      canvas =
        %Canvas{width: 3, height: 3}
        |> Canvas.mark({2, 2}, ".")

      assert canvas.bitmap == %{{2, 2} => "."}
    end
  end
end
