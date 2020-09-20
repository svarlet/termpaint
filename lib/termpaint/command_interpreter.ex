defmodule Termpaint.UnsupportedCommandError do
  defexception ~w{message}a
end

defmodule Termpaint.CommandInterpreter do
  alias Termpaint.{
    UnsupportedCommandError,
    CreateCanvasCommand,
    DrawLineCommand,
    DrawRectangleCommand,
    BucketFillCommand,
    QuitCommand,
    Parser
  }

  defp sanitize(text_command) do
    text_command
    |> String.trim()
    |> String.replace(~r/[[:space:]]+/, " ")
  end

  def parse(string) when is_binary(string) do
    text_command = sanitize(string)

    case Parser.to_supported_command(text_command) do
      {:ok, tokens, _, _, _, _} ->
        case tokens do
          ["C", width, height] ->
            %CreateCanvasCommand{width: width, height: height}

          ["L", x_from, y_from, x_to, y_to] ->
            %DrawLineCommand{from: {x_from, y_from}, to: {x_to, y_to}}

          ["R", x_from, y_from, x_to, y_to] ->
            %DrawRectangleCommand{from: {x_from, y_from}, to: {x_to, y_to}}

          ["B", x, y, ink] ->
            %BucketFillCommand{position: {x, y}, ink: ink}

          ["Q"] ->
            %QuitCommand{}
        end

      {:error, _, _, _, _, _} ->
        %UnsupportedCommandError{}
    end
  end

  def parse(_) do
    %UnsupportedCommandError{}
  end
end
