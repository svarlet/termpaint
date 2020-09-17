defmodule Termpaint.Canvas do
  defstruct width: 0, height: 0, coords: %{}

  def new(width, height) do
    %__MODULE__{width: width, height: height}
  end

  def draw_line(canvas, {x1, 1, x2, 1}) do
    coords = for x <- x1..x2, do: {x, 1}
    Enum.reduce(coords, canvas, fn coord, canvas ->
      %__MODULE__{canvas | coords: Map.put(canvas.coords, coord, "x")}
    end)
  end
end
