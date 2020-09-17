defmodule Termpaint do
  alias Termpaint.{Canvas, Renderer}

  def main(_args) do
    read_command(nil)
  end

  def read_command(state \\ nil) do
    command = IO.gets("enter command: ")

    state
    |> process_command(command)
    |> read_command()
  end

  def process_command(state, command) do
    canvas =
      case command do
        "C" <> dimensions ->
          {width, height} = parse_dimensions(dimensions)
          Canvas.new(width, height)

        "L" <> vector ->
          {x1, y1, x2, y2} = parse_vector(vector)
          Canvas.draw_line(state, x1, y1, x2, y2)

        "R" <> vector ->
          {x1, y1, x2, y2} = parse_vector(vector)
          Canvas.draw_rectangle(state, x1, y1, x2, y2)

        "B" <> fill_args ->
          {x, y, ink} = parse_fill_arguments(fill_args)
          Canvas.fill(state, x, y, ink)

        "Q\n" ->
          System.halt(0)
      end

    print_canvas(canvas)

    canvas
  end

  defp print_canvas(canvas) do
    canvas
    |> Renderer.render_canvas()
    |> IO.write()
  end

  defp parse_fill_arguments(text) do
    %{"x" => x, "y" => y, "ink" => ink} =
      Regex.named_captures(~r/(?<x>\d+)\ +(?<y>\d+)\ +(?<ink>.)/, text)

    {x, _} = Integer.parse(x)
    {y, _} = Integer.parse(y)

    {x, y, ink}
  end

  defp parse_vector(text) do
    %{"x1" => x1, "y1" => y1, "x2" => x2, "y2" => y2} =
      Regex.named_captures(~r/(?<x1>\d+)\ +(?<y1>\d+)\ +(?<x2>\d+)\ +(?<y2>\d+)/, text)

    {x1, _} = Integer.parse(x1)
    {y1, _} = Integer.parse(y1)
    {x2, _} = Integer.parse(x2)
    {y2, _} = Integer.parse(y2)

    {x1, y1, x2, y2}
  end

  defp parse_dimensions(text) do
    %{"width" => width, "height" => height} =
      Regex.named_captures(~r/(?<width>\d+)\ +(?<height>\d+)/, text)

    {width, _} = Integer.parse(width)
    {height, _} = Integer.parse(height)
    {width, height}
  end
end
