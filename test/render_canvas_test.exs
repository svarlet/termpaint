defmodule Termpaint.RenderCanvasTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias Termpaint.{TextRenderer, Canvas}

  test "a 1x1 canvas" do
    canvas =
      %Canvas{width: 1, height: 1}
      |> Canvas.mark({1, 1}, ".")
    assert capture_io(fn -> IO.write(TextRenderer.render(canvas)) end) ==
      """
      ---
      |.|
      ---
      """
  end

  test "a 1x2 canvas" do
    canvas =
      %Canvas{width: 1, height: 2}
      |> Canvas.mark({1, 1}, ".")
    assert capture_io(fn -> IO.write(TextRenderer.render(canvas)) end) ==
      """
      ---
      |.|
      | |
      ---
      """
  end

  test "a 3x3 canvas" do
    canvas =
      %Canvas{width: 3, height: 3}
      |> Canvas.mark({3, 3}, ".")
      |> Canvas.mark({2, 2}, ".")
      |> Canvas.mark({1, 1}, ".")
    assert capture_io(fn -> IO.write(TextRenderer.render(canvas)) end) ==
      """
      -----
      |.  |
      | . |
      |  .|
      -----
      """

  end
end
