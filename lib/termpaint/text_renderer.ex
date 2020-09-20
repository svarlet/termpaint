defmodule Termpaint.TextRenderer do
  @horizontal_fencing "-"
  @vertical_fencing "|"

  def render(canvas) do
    header = String.duplicate(@horizontal_fencing, canvas.width + 2) <> "\n"
    footer = header
    body =
      for y <- 1..canvas.height do
        row =
          for x <- 1..canvas.width do
            canvas.bitmap[{x, y}] || " "
          end
        [@vertical_fencing | List.insert_at(row, -1, "#{@vertical_fencing}\n")]
      end
    [header, body, footer]
  end
end
