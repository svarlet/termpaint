defmodule Termpaint.Canvas do
  defstruct width: 0, height: 0, coords: %{}

  def new(width, height) do
    %__MODULE__{width: width, height: height}
  end

  def draw_line(canvas, {x1, y1, x2, y2}) do
    coords_between({x1, y1}, {x2, y2})
    |> Enum.reduce(canvas, fn coord, canvas ->
      %__MODULE__{canvas | coords: Map.put(canvas.coords, coord, "x")}
    end)
  end

  defp coords_between({x1, y1}, {x2, y2}) do
    horizontal_coords = for x <- x1..x2, do: {x, y1}
    vertical_coords = for y <- y1..y2, do: {x2, y}
    Enum.concat(horizontal_coords, vertical_coords)
  end
end
