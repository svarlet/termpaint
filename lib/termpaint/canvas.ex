defmodule Termpaint.Canvas do
  defstruct width: 0, height: 0

  def new(width, height) do
    %__MODULE__{width: width, height: height}
  end
end
