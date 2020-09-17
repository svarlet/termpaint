defmodule Termpaint do
  alias Termpaint.{Canvas, Renderer}

  def process_command(_state, "C" <> dimensions) do
    {width, height} = parse_dimensions(dimensions)

    Canvas.new(width, height)
    |> Renderer.render_canvas()
  end

  defp parse_dimensions(text) do
    %{"width" => width, "height" => height} =
      Regex.named_captures(~r/(?<width>\d+)\ +(?<height>\d+)/, text)

    {width, _} = Integer.parse(width)
    {height, _} = Integer.parse(height)
    {width, height}
  end
end
