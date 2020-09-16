defmodule Termpaint do
  def process_command("C" <> dimensions) do
    %{"width" => width, "height" => height} = Regex.named_captures(~r/(?<width>\d+)\ +(?<height>\d+)/, dimensions)
    {width, _} = Integer.parse(width)
    {height, _} = Integer.parse(height)
    header = render_header(width)
    body = List.duplicate(render_row(width), height)
    footer = render_footer(width)
    Enum.join([header, body, footer])
  end

  defp render_header(width) do
    "-#{String.duplicate("-", width)}-\n"
  end

  defp render_footer(width), do: "-#{String.duplicate("-", width)}-\n"

  defp render_row(width), do: "|#{String.duplicate(" ", width)}|\n"

end
