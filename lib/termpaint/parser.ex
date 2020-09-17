defmodule Termpaint.Parser do
  def parse_fill_arguments(text) do
    %{"x" => x, "y" => y, "ink" => ink} =
      Regex.named_captures(~r/(?<x>\d+)\ +(?<y>\d+)\ +(?<ink>.)/, text)

    {x, _} = Integer.parse(x)
    {y, _} = Integer.parse(y)

    {x, y, ink}
  end

  def parse_vector(text) do
    %{"x1" => x1, "y1" => y1, "x2" => x2, "y2" => y2} =
      Regex.named_captures(~r/(?<x1>\d+)\ +(?<y1>\d+)\ +(?<x2>\d+)\ +(?<y2>\d+)/, text)

    {x1, _} = Integer.parse(x1)
    {y1, _} = Integer.parse(y1)
    {x2, _} = Integer.parse(x2)
    {y2, _} = Integer.parse(y2)

    {x1, y1, x2, y2}
  end

  def parse_dimensions(text) do
    %{"width" => width, "height" => height} =
      Regex.named_captures(~r/(?<width>\d+)\ +(?<height>\d+)/, text)

    {width, _} = Integer.parse(width)
    {height, _} = Integer.parse(height)
    {width, height}
  end
end
