defmodule TermpaintTest do
  use ExUnit.Case

  test "create a 1x1 canvas" do
    assert Termpaint.process_command("C 1 1") ==
      """
      ---
      | |
      ---
      """
  end
end
