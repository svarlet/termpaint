defmodule Termpaint do
  use Exceptional

  alias Termpaint.{
    CommandInterpreter,
    CanvasTransformation,
    TextRenderer,
    QuitCommand
  }

  def main(_args) do
    nil
    |> Stream.unfold(&run/1)
    |> Stream.run()
  end

  defp run(app_state) do
    new_app_state =
      IO.gets("enter command: ")
      |> CommandInterpreter.parse()
      ~> CanvasTransformation.transform(app_state)
      # ~> tee(&output/1)
      ~> tee(&pretty_print(&1, 1024))

    if_exception(new_app_state) do
      fn %QuitCommand{} -> System.halt()
         _ -> {app_state, app_state}
      end.()
    else
      fn _ -> {app_state, new_app_state} end.()
    end
  end

  defp output(app_state) do
    app_state
    |> TextRenderer.render()
    |> IO.write()
  end

  defp pretty_print(app_state, buffer_size \\ 1) do
    header = String.duplicate("-", app_state.width + 2)

    IO.puts(header)

    app_state
    |> TextRenderer.render_as_stream()
    |> Stream.each(fn row ->
      IO.write("|")
      row
      |> Stream.chunk_every(buffer_size)
      |> Stream.each(fn buffer -> IO.write(buffer) end)
      |> Stream.run()
      # Stream.each(row, fn px -> IO.write(px) end) |> Stream.run()
      IO.write("|\n")
    end)
    |> Stream.run()

    IO.puts(header)
  end

  defp tee(value, fun) do
    fun.(value)
    value
  end

  def bench() do
    alias Termpaint.Canvas

    canvas = %Canvas{width: 10000, height: 10000}
    Benchee.run(
      %{
        "output" => fn -> output(canvas) end,
        "stream - buff: 1024" => fn -> pretty_print(canvas, 1024) end,
      }
    )
  end
end
