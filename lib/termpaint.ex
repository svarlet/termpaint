defmodule Termpaint do
  defmodule State do
    defstruct canvas: nil
  end

  defmodule Canvas do
    defstruct width: 0, height: 0

    def new(width, height) do
      %__MODULE__{width: width, height: height}
    end
  end

  defmodule Renderer do
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

  def new() do
    %Termpaint.State{}
  end

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
