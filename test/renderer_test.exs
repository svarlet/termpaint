defmodule Termpaint.RendererTest do
  use ExUnit.Case, async: true

  alias Termpaint.{Renderer, Canvas}

  test "Blank 1x1 canvas" do
    canvas = Canvas.new(1, 1)

    assert Renderer.render_canvas(canvas) ==
             """
             ---
             | |
             ---
             """
  end

  test "Blank 1x2 canvas" do
    canvas = Canvas.new(1, 2)

    assert Renderer.render_canvas(canvas) ==
             """
             ---
             | |
             | |
             ---
             """
  end

  test "Blank 2x1 canvas" do
    canvas = Canvas.new(2, 1)

    assert Renderer.render_canvas(canvas) ==
            """
            ----
            |  |
            ----
            """
  end

  test "Blank 3x3 canvas" do
    canvas = Canvas.new(3, 3)

    assert Renderer.render_canvas(canvas) ==
            """
            -----
            |   |
            |   |
            |   |
            -----
            """
  end
end
