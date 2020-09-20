defmodule Termpaint.BucketFillTest do
  use ExUnit.Case, async: true

  alias Termpaint.{
    BucketFillCommand,
    CanvasTransformation,
    NilCanvasError
  }

  test "nil canvas" do
    command = %BucketFillCommand{position: {0, 0}, ink: "."}
    assert %NilCanvasError{} == CanvasTransformation.transform(command, nil)
  end
end
