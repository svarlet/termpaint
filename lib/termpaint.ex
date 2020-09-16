defmodule Termpaint do
  def process_command("C" <> dimensions) do
    %{"width" => width, "height" => height} = Regex.named_captures(~r/(?<width>\d+)\ +(?<height>\d+)/, dimensions)
    {width, _} = Integer.parse(width)
    {height, _} = Integer.parse(height)
    header = render_vertical_fencing(width)
    body = List.duplicate(render_row(width), height)
    footer = render_vertical_fencing(width)
    Enum.join([header, body, footer])
  end

  defp render_vertical_fencing(width) do
    "-#{String.duplicate("-", width)}-\n"
  end

  defp render_row(width), do: "|#{String.duplicate(" ", width)}|\n"

end
