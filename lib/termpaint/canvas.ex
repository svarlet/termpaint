defmodule Termpaint.Canvas do
  defstruct width: 1, height: 1, bitmap: %{}

  def within?(canvas, point) do
    {x, _} = point

    x > 0 && x <= canvas.width
  end
end
