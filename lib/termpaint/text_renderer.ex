defmodule Termpaint.TextRenderer do
  @horizontal_fencing "-"
  @vertical_fencing "|"
  @trailing_vertical_fencing "|\n"
  @pristine_pixel " "

  alias Termpaint.Canvas

  def render(canvas) do
    body =
      for y <- 1..canvas.height do
        row =
          for x <- 1..canvas.width do
            canvas.bitmap[{x, y}] || @pristine_pixel
          end
        [@vertical_fencing | List.insert_at(row, -1, @trailing_vertical_fencing)]
      end
    [header(canvas), body, footer(canvas)]
  end

  def render_as_stream(%Canvas{width: w, height: h, bitmap: bitmap}) do
    stop_case = {1, h + 1}
    {1, 1}
    |> Stream.unfold(fn
        ^stop_case -> nil
        {^w, y} -> {{w, y}, {1, y + 1}}
        {x, y} -> {{x, y}, {x + 1, y}}
        end)
    |> Stream.map(fn coord -> Map.get(bitmap, coord, " ") end)
    |> Stream.chunk_every(w)
  end

  defp header(canvas) do
    String.duplicate(@horizontal_fencing, canvas.width + 2) <> "\n"
  end

  defp footer(canvas), do: header(canvas)
end
