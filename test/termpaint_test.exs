defmodule TermpaintTest do
  use ExUnit.Case

  setup do
    [state: Termpaint.new()]
  end

  test "create a 1x1 canvas", context do
    assert Termpaint.process_command(context.state, "C 1 1") ==
      """
      ---
      | |
      ---
      """
  end

  test "create a 1x2 canvas", context do
    assert Termpaint.process_command(context.state, "C 1 2") ==
      """
      ---
      | |
      | |
      ---
      """
  end

  test "create a 2x1 canvas", context do
    assert Termpaint.process_command(context.state, "C 2 1") ==
      """
      ----
      |  |
      ----
      """
  end

  test "create a 2x2 canvas", context do
    assert Termpaint.process_command(context.state, "C 3 3") ==
      """
      -----
      |   |
      |   |
      |   |
      -----
      """
  end
end
