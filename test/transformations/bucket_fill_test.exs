defmodule Termpaint.BucketFillTest do
  use ExUnit.Case, async: true

  import Termpaint.TestHelpers, only: [assert_coords_marked: 2]

  alias Termpaint.{
    BucketFillCommand,
    CanvasTransformation,
    NilCanvasError,
    OutOfBoundsError,
    DrawLineCommand,
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
      {1, 3}, {2, 3}, {3, 3}
    ])
  end

  test "bucket fill at a marked coordinate does not alter the canvas" do
    premarked_position = {2, 2}

    old_canvas =
      %Canvas{width: 3, height: 3}
      |> Canvas.mark(premarked_position, ".")

    new_canvas =
      %BucketFillCommand{position: premarked_position, ink: "c"}
      |> CanvasTransformation.transform(old_canvas)

    assert new_canvas == old_canvas
  end

  test "bucket fills the canvas except all pre-marked positions" do
    old_canvas =
      %Canvas{width: 3, height: 3}
      |> Canvas.mark({3, 1}, ".")
      |> Canvas.mark({1, 3}, ".")

    new_canvas =
      %BucketFillCommand{position: {3, 3}, ink: "c"}
      |> CanvasTransformation.transform(old_canvas)

    assert new_canvas.bitmap == %{
      {1, 1} => "c", {2, 1} => "c", {3, 1} => ".",
      {1, 2} => "c", {2, 2} => "c", {3, 2} => "c",
      {1, 3} => ".", {2, 3} => "c", {3, 3} => "c"
    }
  end

  test "bucket fill does not paint within a fence from outside the fence" do
    canvas = %Canvas{width: 5, height: 5}
    old_canvas = CanvasTransformation.transform(%DrawLineCommand{from: {5, 4}, to: {3, 1}}, canvas)
    new_canvas = CanvasTransformation.transform(%BucketFillCommand{position: {2, 3}, ink: "."}, old_canvas)
    assert new_canvas.bitmap == %{
      {1, 1} => ".", {2, 1} => ".", {3, 1} => "x",
      {1, 2} => ".", {2, 2} => ".", {3, 2} => "x",
      {1, 3} => ".", {2, 3} => ".", {3, 3} => "x",
      {1, 4} => ".", {2, 4} => ".", {3, 4} => "x", {4, 4} => "x", {5, 4} => "x",
      {1, 5} => ".", {2, 5} => ".", {3, 5} => ".", {4, 5} => ".", {5, 5} => "."
    }
  end

  test "2 lines which almost intersect act as a fence" do
    canvas = %Canvas{width: 5, height: 5}
    old_canvas = CanvasTransformation.transform(%DrawLineCommand{from: {3, 1}, to: {3, 3}}, canvas)
    old_canvas = CanvasTransformation.transform(%DrawLineCommand{from: {4, 4}, to: {5, 4}}, old_canvas)
    new_canvas = CanvasTransformation.transform(%BucketFillCommand{position: {2, 3}, ink: "."}, old_canvas)
    assert new_canvas.bitmap == %{
      {1, 1} => ".", {2, 1} => ".", {3, 1} => "x",
      {1, 2} => ".", {2, 2} => ".", {3, 2} => "x",
      {1, 3} => ".", {2, 3} => ".", {3, 3} => "x",
      {1, 4} => ".", {2, 4} => ".", {3, 4} => ".", {4, 4} => "x", {5, 4} => "x",
      {1, 5} => ".", {2, 5} => ".", {3, 5} => ".", {4, 5} => ".", {5, 5} => "."
    }
  end
end
