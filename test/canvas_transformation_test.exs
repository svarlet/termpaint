defmodule CanvasTransformationTest do
  use ExUnit.Case, async: true

  alias Termpaint.{CreateCanvasCommand, AbsurdCanvasSizeError, CanvasTransformation, Canvas}

  test "creating a 0x0 canvas is an error" do
    command = %CreateCanvasCommand{width: 0, height: 0}
    assert %AbsurdCanvasSizeError{} == CanvasTransformation.transform(command, nil)
  end

  test "given a nil canvas, creating a 1x1 canvas returns a 1x1 canvas" do
    command = %CreateCanvasCommand{width: 1, height: 1}
    assert %Canvas{width: 1, height: 1} == CanvasTransformation.transform(command, nil)
  end

  test "given a nil canvas, creating a 10k x 10k canvas returns a 10k x 10k canvas" do
    command = %CreateCanvasCommand{width: 10_000, height: 10_000}
    assert %Canvas{width: 10_000, height: 10_000} == CanvasTransformation.transform(command, nil)
  end
end
