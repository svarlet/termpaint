defmodule Termpaint do
  def process_command("C" <> dimensions) do
    {width, height} = parse_dimensions(dimensions)
    header = render_vertical_fencing(width)
    body = List.duplicate(render_row(width), height)
    footer = render_vertical_fencing(width)
    Enum.join([header, body, footer])
  end

  defp parse_dimensions(text) do
    %{"width" => width, "height" => height} = Regex.named_captures(~r/(?<width>\d+)\ +(?<height>\d+)/, text)
    {width, _} = Integer.parse(width)
    {height, _} = Integer.parse(height)
    {width, height}
  end

  defp render_vertical_fencing(width) do
    "-#{String.duplicate("-", width)}-\n"
  end

  defp render_row(width) do
    "|#{String.duplicate(" ", width)}|\n"
  end

end
