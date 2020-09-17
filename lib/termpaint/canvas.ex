defmodule Termpaint.Canvas do
  defstruct width: 0, height: 0, coords: %{}

  def new(width, height) do
    %__MODULE__{width: width, height: height}
  end

  def draw_line(canvas, {1, 1, 1, 1}) do
    %__MODULE__{canvas | coords: Map.put(canvas.coords, {1, 1}, "x")}
  end

end
