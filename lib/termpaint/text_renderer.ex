defmodule Termpaint.TextRenderer do
  @horizontal_fencing "-"
  @vertical_fencing "|"
  @pristine_pixel " "

  def render(canvas) do
    body =
      for y <- 1..canvas.height do
        row =
          for x <- 1..canvas.width do
            canvas.bitmap[{x, y}] || @pristine_pixel
          end
        [@vertical_fencing | List.insert_at(row, -1, "#{@vertical_fencing}\n")]
      end
    [header(canvas), body, footer(canvas)]
  end

  defp header(canvas) do
    String.duplicate(@horizontal_fencing, canvas.width + 2) <> "\n"
  end

  defp footer(canvas), do: header(canvas)
end
