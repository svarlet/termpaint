defmodule Termpaint.Canvas do
  @ink "x"

  defstruct width: 0, height: 0, coords: %{}

  def new(width, height) do
    %__MODULE__{width: width, height: height}
  end

  def draw_line(canvas, x1, y1, x2, y2) do
    coords_between({x1, y1}, {x2, y2})
    |> Enum.reduce(canvas, fn coord, canvas -> paint_at(canvas, coord, @ink) end)
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
    fill_rec(canvas, ink, [{x, y}])
  end

  defp fill_rec(canvas, _ink, []) do
    canvas
  end

  defp fill_rec(canvas, ink, [coord | candidates]) do
    if canvas.coords[coord] == nil do
      canvas = paint_at(canvas, coord, ink)
      new_candidates = surrounding_coords_of(canvas, coord)
      fill_rec(canvas, ink, Enum.concat(new_candidates, candidates))
    else
      fill_rec(canvas, ink, candidates)
    end
  end

  defp paint_at(canvas, coord, ink) do
    %__MODULE__{canvas | coords: Map.put_new(canvas.coords, coord, ink)}
  end

  defp surrounding_coords_of(canvas, {x, y}) do
    [
      {x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1},
      {x - 1, y}, {x + 1, y},
      {x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1}
    ]
    |> Enum.filter(fn {x, _y} -> x >= 1 and x <= canvas.width end)
    |> Enum.filter(fn {_x, y} -> y >= 1 and y <= canvas.height end)
  end
end
