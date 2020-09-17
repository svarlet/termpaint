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

  test "3x3 canvas with a {1,1} dot" do
    canvas =
      Canvas.new(3, 3)
      |> Canvas.draw_line(1, 1, 1, 1)

    assert Renderer.render_canvas(canvas) ==
             """
             -----
             |x  |
             |   |
             |   |
             -----
             """
  end

  test "3x3 canvas with various spots" do
    canvas = Canvas.new(3, 3)
    marks = %{
      {1, 1} => "x",
      {2, 1} => "0",
      {3, 2} => "9",
      {1, 2} => "S",
      {3, 1} => ".",
    }

    canvas = %Canvas{canvas | coords: marks}
    assert Renderer.render_canvas(canvas) ==
             """
             -----
             |x0.|
             |S 9|
             |   |
             -----
             """
  end
end
