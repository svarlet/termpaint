defmodule CanvasTransformationTest do
  use ExUnit.Case, async: true

  alias Termpaint.{CreateCanvasCommand, AbsurdCanvasSizeError, CanvasTransformation, Canvas}

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
end
