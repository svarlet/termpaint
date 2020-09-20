defmodule Termpaint.AbsurdCanvasSizeError do
  defexception ~w{message}a
end

defmodule Termpaint.NilCanvasError do
  defexception ~w{message}a
end

defmodule Termpaint.OutOfBoundsError do
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
  alias Termpaint.{NilCanvasError, DrawLineCommand, Canvas, OutOfBoundsError}

  defstruct from: {1, 1}, to: {1, 1}

  defimpl Termpaint.CanvasTransformation do
    @dot "x"

    def transform(_command, nil) do
      %NilCanvasError{}
    end

    def transform(%DrawLineCommand{from: from, to: to}, canvas) do
      cond do
        not Canvas.within?(canvas, from) -> %OutOfBoundsError{}
        not Canvas.within?(canvas, to) -> %OutOfBoundsError{}
        true ->
          {x_from, y_from} = from
          {x_to, y_to} = to
          canvas =
            for x <- x_from..x_to, reduce: canvas do
              canvas -> %Canvas{canvas | bitmap: Map.put(canvas.bitmap, {x, y_from}, @dot)}
            end

          for y <- y_from..y_to, reduce: canvas do
            canvas -> %Canvas{canvas | bitmap: Map.put(canvas.bitmap, {x_to, y}, @dot)}
          end
      end
    end
  end
end

defmodule Termpaint.DrawRectangleCommand do
  alias Termpaint.{CanvasTransformation, NilCanvasError, OutOfBoundsError, Canvas}

  defstruct from: {1, 1}, to: {1, 1}

  defimpl CanvasTransformation do
    @ink "x"

    def transform(_command, nil), do: %NilCanvasError{}

    def transform(command, canvas) do
      cond do
        not Canvas.within?(canvas, command.from) -> %OutOfBoundsError{}
        not Canvas.within?(canvas, command.to) -> %OutOfBoundsError{}
        command.from == command.to ->
          %Canvas{canvas | bitmap: Map.put(canvas.bitmap, command.from, @ink)}
        true ->
          {x_from, y_from} = command.from
          {x_to, y_to} = command.to
          %Canvas{canvas | bitmap:
            canvas.bitmap
            |> Map.put(command.from, @ink)
            |> Map.put(command.to, @ink)
            |> Map.put({x_from, y_to}, @ink)
            |> Map.put({x_to, y_from}, @ink)
          }
      end
    end
  end
end

defmodule Termpaint.BucketFillCommand do
  defstruct position: {1, 1}, ink: "."
end

defmodule Termpaint.QuitCommand do
  defstruct []
end
