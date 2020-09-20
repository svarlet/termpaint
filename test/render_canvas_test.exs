defmodule Termpaint.RenderCanvasTest do
  use ExUnit.Case, async: true

  alias Termpaint.{TextRenderer, Canvas}

  test "a 1x1 canvas" do
    canvas =
      %Canvas{width: 1, height: 1}
      |> Canvas.mark({1, 1}, ".")
    assert TextRenderer.render(canvas) ==
      """
      ---
      |.|
      ---
      """
  end
end
