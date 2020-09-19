defmodule Termpaint.AbsurdCanvasSizeError do
  defexception ~w{message}a
end

defmodule Termpaint.CreateCanvasCommand do
  alias Termpaint.AbsurdCanvasSizeError
  alias Termpaint.Canvas

  defstruct width: 1, height: 1

  defimpl Termpaint.CanvasTransformation do
    alias Termpaint.CreateCanvasCommand

    def transform(%CreateCanvasCommand{width: 0, height: _}, _canvas) do
      %AbsurdCanvasSizeError{}
    end

    def transform(%CreateCanvasCommand{width: _, height: 0}, _canvas) do
      %AbsurdCanvasSizeError{}
    end

    def transform(%CreateCanvasCommand{width: width, height: height}, _canvas) do
      %Canvas{width: width, height: height}
    end
  end
end

defmodule Termpaint.DrawLineCommand do
  defstruct from: {1, 1}, to: {1, 1}
end

defmodule Termpaint.DrawRectangleCommand do
  defstruct from: {1, 1}, to: {1, 1}
end

defmodule Termpaint.BucketFillCommand do
  defstruct position: {1, 1}, ink: "."
end

defmodule Termpaint.QuitCommand do
  defstruct []
end