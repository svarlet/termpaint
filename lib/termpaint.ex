defmodule Termpaint do
  alias Termpaint.{Printer, CommandInterpreter}

  @prompt "enter command: "

  def main(_args) do
    Stream.unfold(nil, &run/1)
    |> Stream.run()
  end

  defp run(state) do
    command = IO.gets(@prompt)
    new_state = CommandInterpreter.process_command(state, command)
    Printer.print_canvas(new_state)
    {state, new_state}
  end
end
