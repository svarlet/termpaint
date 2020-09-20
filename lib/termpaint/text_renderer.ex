defmodule Termpaint.TextRenderer do
  def render(canvas) do
    header = String.duplicate("-", canvas.width + 2) <> "\n"
    footer = header
    body =
      for y <- 1..canvas.height do
        row =
          for x <- 1..canvas.width do
            canvas.bitmap[{x, y}] || " "
          end
        ["|" | List.insert_at(row, -1, "|\n")]
      end
    [header, body, footer]
  end
end
