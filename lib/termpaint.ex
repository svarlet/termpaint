defmodule Termpaint do
  alias Termpaint.{Canvas, Renderer}

  import Termpaint.Parser

  def main(_args) do
    Stream.unfold(nil, &run/1)
    |> Stream.run()
  end

  defp run(state) do
    command = IO.gets("enter command: ")
    new_state = process_command(state, command)
    {state, new_state}
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


end
