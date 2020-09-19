defmodule CanvasTransformationTest do
  use ExUnit.Case, async: true

  alias Termpaint.{CreateCanvasCommand, AbsurdCanvasSizeError, CanvasTransformation}

  test "creating a 0x0 canvas is an error" do
    command = %CreateCanvasCommand{width: 0, height: 0}
    assert %AbsurdCanvasSizeError{} == CanvasTransformation.transform(command, nil)
  end
end
