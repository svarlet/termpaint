defmodule Termpaint.Canvas do
  @ink "x"

  defstruct width: 0, height: 0, coords: %{}

  def new(width, height) do
    %__MODULE__{width: width, height: height}
  end

  def draw_line(canvas, x1, y1, x2, y2) do
    coords_between({x1, y1}, {x2, y2})
    |> Enum.reduce(canvas, fn coord, canvas ->
      %__MODULE__{canvas | coords: Map.put(canvas.coords, coord, @ink)}
    end)
  end

  defp coords_between({x1, y1}, {x2, y2}) do
    horizontal_coords = for x <- x1..x2, do: {x, y1}
    vertical_coords = for y <- y1..y2, do: {x2, y}
    Enum.concat(horizontal_coords, vertical_coords)
  end

  def draw_rectangle(canvas, x1, y1, x2, y2) do
    canvas
    |> draw_line(x1, y1, x2, y2)
    |> draw_line(x2, y2, x1, y1)
  end

  def fill(canvas, x, y, ink) do
    if canvas.coords[{x, y}] == nil do
      all_coords =
        for i <- 1..canvas.width, j <- 1..canvas.height do
          {i, j}
        end

      Enum.reduce(all_coords, canvas, fn coord, canvas ->
        %__MODULE__{canvas | coords: Map.put(canvas.coords, coord, ink)}
      end)
    else
      canvas
    end
  end
end
