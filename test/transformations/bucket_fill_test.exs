defmodule Termpaint.BucketFillTest do
  use ExUnit.Case, async: true

  import Termpaint.TestHelpers, only: [assert_coords_marked: 2]

  alias Termpaint.{
    BucketFillCommand,
    CanvasTransformation,
    NilCanvasError,
    OutOfBoundsError,
    Canvas
  }

  test "nil canvas" do
    command = %BucketFillCommand{position: {0, 0}, ink: "."}
    assert %NilCanvasError{} == CanvasTransformation.transform(command, nil)
  end

  test "from a position outside the boundaries of the canvas" do
    canvas = %Canvas{width: 3, height: 3}

    command = %BucketFillCommand{position: {0, 1}, ink: "."}
    assert %OutOfBoundsError{} == CanvasTransformation.transform(command, canvas)

    command = %BucketFillCommand{position: {1, 0}, ink: "."}
    assert %OutOfBoundsError{} == CanvasTransformation.transform(command, canvas)

    command = %BucketFillCommand{position: {8, 1}, ink: "."}
    assert %OutOfBoundsError{} == CanvasTransformation.transform(command, canvas)

    command = %BucketFillCommand{position: {1, 8}, ink: "."}
    assert %OutOfBoundsError{} == CanvasTransformation.transform(command, canvas)
  end

  test "entirely fills the canvas if it's empty" do
    canvas = %Canvas{width: 3, height: 3}
    command = %BucketFillCommand{position: {2, 1}, ink: "x"}
    canvas = CanvasTransformation.transform(command, canvas)
    assert_coords_marked(canvas.bitmap, [
      {1, 1}, {2, 1}, {3, 1},
      {1, 2}, {2, 2}, {3, 2},
      {1, 3}, {2, 3}, {3, 3},
    ])
  end
end
