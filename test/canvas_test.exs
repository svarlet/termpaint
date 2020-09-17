defmodule Termpaint.CanvasTest do
  use ExUnit.Case, async: true

  alias Termpaint.Canvas

  describe "blank canvas" do
    test "a new 1x1 canvas" do
      assert %Canvas{width: 1, height: 1} == Canvas.new(1, 1)
    end

    test "a new 2x7 canvas" do
      assert %Canvas{width: 2, height: 7} == Canvas.new(2, 7)
    end
  end

  describe "lines" do
    test "a (1, 1) to (1, 1) line" do
      canvas =
        Canvas.new(1, 1)
        |> Canvas.draw_line(1, 1, 1, 1)

      assert canvas.coords == %{{1, 1} => "x"}
    end

    test "a horizontal line" do
      canvas =
        Canvas.new(3, 3)
        |> Canvas.draw_line(1, 1, 3, 1)

      assert canvas.coords == %{
               {1, 1} => "x",
               {2, 1} => "x",
               {3, 1} => "x"
             }
    end

    test "a vertical line" do
      canvas =
        Canvas.new(3, 3)
        |> Canvas.draw_line(1, 1, 1, 3)

      assert canvas.coords == %{
               {1, 1} => "x",
               {1, 2} => "x",
               {1, 3} => "x"
             }
    end

    test "an oblique line" do
      canvas =
        Canvas.new(3, 3)
        |> Canvas.draw_line(1, 1, 3, 3)

      assert canvas.coords == %{
               {1, 1} => "x",
               {2, 1} => "x",
               {3, 1} => "x",
               {3, 2} => "x",
               {3, 3} => "x"
             }
    end
  end

  describe "rectangles" do
    test "a 1px rectangle" do
      canvas =
        Canvas.new(3, 3)
        |> Canvas.draw_rectangle(1, 1, 1, 1)

      assert canvas.coords == %{
               {1, 1} => "x"
             }
    end

    test "a height-less rectangle is equivalent to a line" do
      canvas =
        Canvas.new(3, 3)
        |> Canvas.draw_rectangle(1, 1, 3, 1)

      assert canvas.coords == %{
               {1, 1} => "x",
               {2, 1} => "x",
               {3, 1} => "x"
             }
    end

    test "a width-less rectangle is a vertical line" do
      canvas =
        Canvas.new(3, 3)
        |> Canvas.draw_rectangle(1, 1, 1, 3)

      assert canvas.coords == %{
               {1, 1} => "x",
               {1, 2} => "x",
               {1, 3} => "x"
             }
    end

    test "a 2x2 rectangle has no hole in the middle" do
      canvas =
        Canvas.new(3, 3)
        |> Canvas.draw_rectangle(2, 2, 3, 3)

      assert canvas.coords == %{
               {2, 2} => "x",
               {2, 3} => "x",
               {3, 2} => "x",
               {3, 3} => "x"
             }
    end

    test "a 3x3 rectangle has a hole at {2,2}" do
      canvas =
        Canvas.new(3, 3)
        |> Canvas.draw_rectangle(1, 1, 3, 3)

      assert canvas.coords == %{
               {1, 1} => "x",
               {1, 2} => "x",
               {1, 3} => "x",
               {2, 1} => "x",
               {2, 3} => "x",
               {3, 1} => "x",
               {3, 2} => "x",
               {3, 3} => "x"
             }
    end
  end
end
