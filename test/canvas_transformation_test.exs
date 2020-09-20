defmodule CanvasTransformationTest do
  use ExUnit.Case, async: true

  alias Termpaint.{
    CreateCanvasCommand,
    AbsurdCanvasSizeError,
    CanvasTransformation,
    Canvas,
    DrawLineCommand,
    NilCanvasError,
    OutOfBoundsError,
    DrawRectangleCommand
  }

  describe "create a canvas" do
    test "creating a 0x0 canvas is an error" do
      command = %CreateCanvasCommand{width: 0, height: 0}
      assert %AbsurdCanvasSizeError{} == CanvasTransformation.transform(command, nil)
    end

    test "creating a 0x0 canvas from a previous canvas returns an error" do
      command = %CreateCanvasCommand{width: 0, height: 0}
      prior_canvas = %Canvas{width: 1, height: 1}
      assert %AbsurdCanvasSizeError{} == CanvasTransformation.transform(command, prior_canvas)
    end

    test "creating a 0xN canvas returns an error" do
      command = %CreateCanvasCommand{width: 0, height: 10}
      assert %AbsurdCanvasSizeError{} == CanvasTransformation.transform(command, nil)
    end

    test "creating a Nx0 canvas returns an error" do
      command = %CreateCanvasCommand{width: 1, height: 0}
      assert %AbsurdCanvasSizeError{} == CanvasTransformation.transform(command, nil)
    end

    test "given a nil canvas, creating a 1x1 canvas returns a 1x1 canvas" do
      command = %CreateCanvasCommand{width: 1, height: 1}
      assert %Canvas{width: 1, height: 1} == CanvasTransformation.transform(command, nil)
    end

    test "given a nil canvas, creating a 10k x 10k canvas returns a 10k x 10k canvas" do
      command = %CreateCanvasCommand{width: 10_000, height: 10_000}

      assert %Canvas{width: 10_000, height: 10_000} ==
               CanvasTransformation.transform(command, nil)
    end

    test "given a preexising canvas, creating a canvas returns the new one" do
      command = %CreateCanvasCommand{width: 10_000, height: 10_000}
      prior_canvas = %Canvas{width: 1, height: 1}

      assert %Canvas{width: 10_000, height: 10_000} ==
               CanvasTransformation.transform(command, prior_canvas)
    end

    test "creating a canvas initialises an empty bitmap within the canvas" do
      canvas =
        %CreateCanvasCommand{width: 10_000, height: 10_000}
        |> CanvasTransformation.transform(nil)

      assert canvas.bitmap == %{}
    end
  end

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

    defp assert_coords_marked(bitmap, coords) do
      expected_bitmap = for coord <- coords, into: %{}, do: {coord, "x"}
      assert expected_bitmap == bitmap
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

  describe "drawing a rectangle" do
    test "nil canvas" do
      rectangle_command = %DrawRectangleCommand{from: {1, 1}, to: {3, 3}}
      assert %NilCanvasError{} == CanvasTransformation.transform(rectangle_command, nil)
    end

    test "rectangle corners outside the boundaries of the canvas" do
      canvas = %Canvas{width: 3, height: 3}

      rectangle_command = %DrawRectangleCommand{from: {0, 1}, to: {3, 3}}
      assert %OutOfBoundsError{} == CanvasTransformation.transform(rectangle_command, canvas)

      rectangle_command = %DrawRectangleCommand{from: {1, 0}, to: {3, 3}}
      assert %OutOfBoundsError{} == CanvasTransformation.transform(rectangle_command, canvas)

      rectangle_command = %DrawRectangleCommand{from: {1, 1}, to: {4, 3}}
      assert %OutOfBoundsError{} == CanvasTransformation.transform(rectangle_command, canvas)

      rectangle_command = %DrawRectangleCommand{from: {1, 1}, to: {3, 4}}
      assert %OutOfBoundsError{} == CanvasTransformation.transform(rectangle_command, canvas)
    end

    test "a 1x1 rectangle is 1 pixel" do
      canvas = %Canvas{width: 3, height: 3}
      command = %DrawRectangleCommand{from: {2, 2}, to: {2, 2}}
      canvas = CanvasTransformation.transform(command, canvas)
      assert_coords_marked(canvas.bitmap, [{2, 2}])
    end

    test "a 2x2 rectangle has no other pixels than its corners" do
      canvas = %Canvas{width: 3, height: 3}
      command = %DrawRectangleCommand{from: {2, 2}, to: {3, 3}}
      canvas = CanvasTransformation.transform(command, canvas)
      assert_coords_marked(canvas.bitmap, [{2, 2}, {2, 3}, {3, 2}, {3, 3}])
    end

    test "a 3x3 rectangle has a 1px hole in its center" do
      canvas = %Canvas{width: 3, height: 3}
      command = %DrawRectangleCommand{from: {1, 1}, to: {3, 3}}
      canvas = CanvasTransformation.transform(command, canvas)
      assert_coords_marked(canvas.bitmap, [
        {1, 1}, {2, 1}, {3, 1},
        {1, 2},         {3, 2},
        {1, 3}, {2, 3}, {3, 3},
      ])
    end
  end
end
