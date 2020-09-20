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
      ~> tee(&output/1)

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

  defp tee(value, fun) do
    fun.(value)
    value
  end
end
