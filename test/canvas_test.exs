defmodule Termpaint.CanvasTest do
  use ExUnit.Case, async: true

  alias Termpaint.Canvas

  test "a new 1x1 canvas" do
    assert %Canvas{width: 1, height: 1} == Canvas.new(1,1)
  end
end
