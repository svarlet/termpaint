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
  end
end
