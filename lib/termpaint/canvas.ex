defmodule Termpaint.Canvas do
  defstruct width: 1, height: 1, bitmap: %{}

  def within?(canvas, point) do
    {x, y} = point

    x > 0 && x <= canvas.width && y > 0 && y <= canvas.height
  end
end
