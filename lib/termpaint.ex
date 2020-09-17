defmodule Termpaint do
  @vertical_fencing_char "-"
  @horizontal_fencing_char "|"
  @blank_char " "

  defmodule State do
    defstruct canvas: nil
  end

  defmodule Canvas do
    defstruct width: 0, height: 0

    def new(width, height) do
      %__MODULE__{width: width, height: height}
    end
  end

  def new() do
    %Termpaint.State{}
  end

  def process_command(_state, "C" <> dimensions) do
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
