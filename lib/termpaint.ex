defmodule Termpaint do
  alias Termpaint.{
    CommandInterpreter,
    CanvasTransformation,
    TextRenderer
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
      |> CanvasTransformation.transform(app_state)
      |> tee(&output/1)

    {app_state, new_app_state}
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
