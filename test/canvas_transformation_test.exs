defmodule CanvasTransformationTest do
  use ExUnit.Case, async: true

  alias Termpaint.{
    CreateCanvasCommand,
    AbsurdCanvasSizeError,
    CanvasTransformation,
    Canvas,
    DrawLineCommand,
    NilCanvasError,
    OutOfBoundsError
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
    test "drawing a line before a canvas is created" do
      assert %NilCanvasError{} ==
               %DrawLineCommand{from: {1, 1}, to: {3, 2}}
               |> CanvasTransformation.transform(nil)
    end

    test "drawing a line from a position outside the canvas returns an error" do
      a_3x3_canvas = %Canvas{width: 3, height: 3}

      assert %OutOfBoundsError{} ==
        %DrawLineCommand{from: {0, 0}, to: {2, 3}}
        |> CanvasTransformation.transform(a_3x3_canvas)
    end

    test "drawing a line to a position outside the canvas returns an error" do
      a_3x3_canvas = %Canvas{width: 3, height: 3}

      assert %OutOfBoundsError{} ==
        %DrawLineCommand{from: {1, 1}, to: {100, 100}}
        |> CanvasTransformation.transform(a_3x3_canvas)
    end

    test "draw a 1px line" do
      a_1px_line_command = %DrawLineCommand{from: {2, 3}, to: {2, 3}}
      a_3x3_canvas = %Canvas{width: 3, height: 3}
      canvas = CanvasTransformation.transform(a_1px_line_command, a_3x3_canvas)
      assert %{{2, 3} => "x"} == canvas.bitmap
    end
  end
end
