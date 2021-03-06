defmodule Termpaint.DrawLineTest do
  use ExUnit.Case, async: true

  import Termpaint.TestHelpers, only: [assert_coords_marked: 2]

  alias Termpaint.{
    CanvasTransformation,
    Canvas,
    DrawLineCommand,
    NilCanvasError,
    OutOfBoundsError
  }

  describe "drawing a line" do
    setup do
      [a_3x3_canvas: %Canvas{width: 3, height: 3}]
    end

    test "drawing a line before a canvas is created" do
      assert %NilCanvasError{} ==
               %DrawLineCommand{from: {1, 1}, to: {3, 2}}
               |> CanvasTransformation.transform(nil)
    end

    test "drawing a line from a position outside the canvas returns an error", context do
      assert %OutOfBoundsError{} ==
               %DrawLineCommand{from: {0, 0}, to: {2, 3}}
               |> CanvasTransformation.transform(context.a_3x3_canvas)
    end

    test "drawing a line to a position outside the canvas returns an error", context do
      assert %OutOfBoundsError{} ==
               %DrawLineCommand{from: {1, 1}, to: {100, 100}}
               |> CanvasTransformation.transform(context.a_3x3_canvas)
    end

    test "draw a 1px line", context do
      a_1px_line_command = %DrawLineCommand{from: {2, 3}, to: {2, 3}}
      canvas = CanvasTransformation.transform(a_1px_line_command, context.a_3x3_canvas)
      assert_coords_marked(canvas.bitmap, [{2, 3}])
    end

    test "draw a horizontal line", context do
      a_hline_command = %DrawLineCommand{from: {1, 2}, to: {3, 2}}
      canvas = CanvasTransformation.transform(a_hline_command, context.a_3x3_canvas)
      assert_coords_marked(canvas.bitmap, [{1, 2}, {2, 2}, {3, 2}])
    end

    test "draw a vertical line", context do
      a_vline_command = %DrawLineCommand{from: {2, 1}, to: {2, 3}}
      canvas = CanvasTransformation.transform(a_vline_command, context.a_3x3_canvas)
      assert_coords_marked(canvas.bitmap, [{2, 1}, {2, 2}, {2, 3}])
    end

    test "a diagonal line is drawn as a horizontal line and a vertical line", context do
      a_diagonal_command = %DrawLineCommand{from: {1, 1}, to: {3, 3}}
      canvas = CanvasTransformation.transform(a_diagonal_command, context.a_3x3_canvas)
      assert_coords_marked(canvas.bitmap, [{1, 1}, {2, 1}, {3, 1}, {3, 2}, {3, 3}])
    end

    test "diagonal toward the top left corner", context do
      a_diagonal_command = %DrawLineCommand{from: {2, 3}, to: {1, 2}}
      canvas = CanvasTransformation.transform(a_diagonal_command, context.a_3x3_canvas)
      assert_coords_marked(canvas.bitmap, [{1, 2}, {1, 3}, {2, 3}])
    end

    test "diagonal toward the bottom left corner", context do
      a_diagonal_command = %DrawLineCommand{from: {3, 1}, to: {2, 2}}
      canvas = CanvasTransformation.transform(a_diagonal_command, context.a_3x3_canvas)
      assert_coords_marked(canvas.bitmap, [{3, 1}, {2, 1}, {2, 2}])
    end

    test "a diagonal towards the top right corner", context do
      a_diagonal_command = %DrawLineCommand{from: {1, 3}, to: {3, 2}}
      canvas = CanvasTransformation.transform(a_diagonal_command, context.a_3x3_canvas)
      assert_coords_marked(canvas.bitmap, [{1, 3}, {2, 3}, {3, 3}, {3, 2}])
    end

    test "drawing a line overwrites previously marked coords" do
      a_line_command = %DrawLineCommand{from: {1, 1}, to: {2, 3}}
      bitmap_of_dots = for x <- 1..3, y <- 1..3, into: %{}, do: {{x, y}, "."}
      canvas = %Canvas{width: 3, height: 3, bitmap: bitmap_of_dots}
      canvas = CanvasTransformation.transform(a_line_command, canvas)

      assert canvas.bitmap == %{
               {1, 1} => "x",
               {2, 1} => "x",
               {3, 1} => ".",
               {1, 2} => ".",
               {2, 2} => "x",
               {3, 2} => ".",
               {1, 3} => ".",
               {2, 3} => "x",
               {3, 3} => "."
             }
    end
  end
end
