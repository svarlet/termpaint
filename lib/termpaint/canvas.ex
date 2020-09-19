defmodule Termpaint.Canvas do
  defstruct width: 1, height: 1, bitmap: %{}

  def within?(canvas, point) do
    {x, y} = point

    x in 1..canvas.width && y in 1..canvas.height
  end
end
