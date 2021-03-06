defmodule Termpaint.Canvas do
  defstruct width: 1, height: 1, bitmap: %{}

  def within?(canvas, point) do
    {x, y} = point

    x in 1..canvas.width && y in 1..canvas.height
  end

  def mark(canvas, coordinate, ink) do
    %__MODULE__{canvas | bitmap: Map.put(canvas.bitmap, coordinate, ink)}
  end

  def neighbours(canvas, {x, y}) do
    [{x, y + 1}, {x + 1, y}, {x, y - 1}, {x - 1, y}]
    |> Enum.filter(&within?(canvas, &1))
  end
end
