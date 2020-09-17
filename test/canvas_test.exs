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

  describe "bucket fill" do
    test "given a blank canvas, fills the entire canvas" do
      canvas =
        Canvas.new(2, 2)
        |> Canvas.fill(1, 2, ".")

      assert canvas.coords == %{
        {1, 1} => ".",
        {2, 1} => ".",
        {1, 2} => ".",
        {2, 2} => "."
      }
    end

    test "returns identical canvas if position is already painted" do
      canvas =
        Canvas.new(2, 2)
        |> Canvas.draw_line(1, 2, 1, 2)

      assert canvas == Canvas.fill(canvas, 1, 2, ".")
    end

    test "does not alter painted coordinates" do
      canvas =
        Canvas.new(2, 2)
        |> Canvas.draw_line(1, 2, 1, 2)
        |> Canvas.fill(1, 1, ".")

      assert canvas.coords == %{
        {1, 1} => ".",
        {1, 2} => "x",
        {2, 1} => ".",
        {2, 2} => "."
      }
    end

    test "does not paint fenced coordinates" do
      canvas =
        Canvas.new(5, 5)
        |> Canvas.draw_rectangle(2, 2, 4, 4)
        |> Canvas.fill(1, 1, "+")

      assert canvas.coords == %{
        {1, 1} => "+",
        {2, 1} => "+",
        {3, 1} => "+",
        {4, 1} => "+",
        {5, 1} => "+",

        {1, 2} => "+",
        {5, 2} => "+",
        {1, 3} => "+",
        {5, 3} => "+",
        {1, 4} => "+",
        {5, 4} => "+",

        {1, 5} => "+",
        {2, 5} => "+",
        {3, 5} => "+",
        {4, 5} => "+",
        {5, 5} => "+",

        {2, 2} => "x",
        {3, 2} => "x",
        {4, 2} => "x",
        {2, 3} => "x",
        {4, 3} => "x",
        {2, 4} => "x",
        {3, 4} => "x",
        {4, 4} => "x",
      }
    end
  end
end
