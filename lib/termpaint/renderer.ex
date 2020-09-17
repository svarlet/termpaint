defmodule Termpaint.Renderer do
  @vertical_fencing_char "-"
  @horizontal_fencing_char "|"
  @blank_char " "

  def render_canvas(canvas) do
    header = render_vertical_fencing(canvas.width)
    body = List.duplicate(render_row(canvas.width), canvas.height)
    footer = render_vertical_fencing(canvas.width)
    Enum.join([header, body, footer])
  end

  defp render_vertical_fencing(width) do
    @vertical_fencing_char
    |> String.duplicate(width)
    |> surround(@vertical_fencing_char)
    |> newline()
  end

  defp render_row(width) do
    @blank_char
    |> String.duplicate(width)
    |> surround(@horizontal_fencing_char)
    |> newline()
  end

  defp surround(string, padding) do
    "#{padding}#{string}#{padding}"
  end

  defp newline(string), do: "#{string}\n"
end
