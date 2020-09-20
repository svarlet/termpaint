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
    @ink "x"

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
              canvas -> mark(canvas, {x, y_from})
            end

          for y <- y_from..y_to, reduce: canvas do
            canvas -> mark(canvas, {x_to, y})
          end
      end
    end

    defp mark(canvas, coordinate), do: Canvas.mark(canvas, coordinate, @ink)
  end
end

defmodule Termpaint.DrawRectangleCommand do
  alias Termpaint.{CanvasTransformation, NilCanvasError, OutOfBoundsError, Canvas, DrawLineCommand}

  defstruct from: {1, 1}, to: {1, 1}

  defimpl CanvasTransformation do
    def transform(_command, nil), do: %NilCanvasError{}

    def transform(command, canvas) do
      cond do
        not Canvas.within?(canvas, command.from) -> %OutOfBoundsError{}
        not Canvas.within?(canvas, command.to) -> %OutOfBoundsError{}
        true ->
          canvas = CanvasTransformation.transform(%DrawLineCommand{from: command.from, to: command.to}, canvas)
          CanvasTransformation.transform(%DrawLineCommand{from: command.to, to: command.from}, canvas)
      end
    end
  end
end

defmodule Termpaint.BucketFillCommand do
  alias Termpaint.{
    CanvasTransformation,
    NilCanvasError,
    OutOfBoundsError,
    Canvas
  }

  defstruct position: {1, 1}, ink: "."

  defimpl CanvasTransformation do
    def transform(_, nil), do: %NilCanvasError{}

    def transform(command, canvas) do
      cond do
        not Canvas.within?(canvas, command.position) -> %OutOfBoundsError{}
        canvas.bitmap[command.position] -> canvas
        true ->
          for x <- 1..canvas.width, y <- 1..canvas.height, reduce: canvas do
            canvas ->
              if canvas.bitmap[{x, y}] do
                canvas
              else
                Canvas.mark(canvas, {x, y}, command.ink)
              end
          end
      end
    end
  end
end

defmodule Termpaint.QuitCommand do
  defstruct []
end
