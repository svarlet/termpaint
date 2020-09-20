defmodule CanvasTransformationTest do
  use ExUnit.Case, async: true

  import Termpaint.TestHelpers, only: [assert_coords_marked: 2]

  alias Termpaint.{
    CanvasTransformation,
    Canvas,
    NilCanvasError,
    OutOfBoundsError,
    DrawRectangleCommand
  }

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

    test "a 3x1 rectangle is a horizontal line" do
      canvas = %Canvas{width: 3, height: 3}
      command = %DrawRectangleCommand{from: {1, 1}, to: {3, 1}}
      canvas = CanvasTransformation.transform(command, canvas)
      assert_coords_marked(canvas.bitmap, [{1, 1}, {2, 1}, {3, 1}])
    end

    test "a 1x3 rectangle is a vertical line" do
      canvas = %Canvas{width: 3, height: 3}
      command = %DrawRectangleCommand{from: {1, 1}, to: {1, 3}}
      canvas = CanvasTransformation.transform(command, canvas)
      assert_coords_marked(canvas.bitmap, [{1, 3}, {1, 2}, {1, 1}])
    end

    test "a 5x5 rectangle has a 3x3 untouched surface in the center" do
      canvas = %Canvas{width: 5, height: 5}
      command = %DrawRectangleCommand{from: {1, 1}, to: {5, 5}}
      canvas = CanvasTransformation.transform(command, canvas)
      assert_coords_marked(canvas.bitmap, [
        {1, 1}, {2, 1}, {3, 1}, {4, 1}, {5, 1},
        {1, 2},                         {5, 2},
        {1, 3},                         {5, 3},
        {1, 4},                         {5, 4},
        {1, 5}, {2, 5}, {3, 5}, {4, 5}, {5, 5},
      ])
    end
  end
end
