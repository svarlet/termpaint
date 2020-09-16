defmodule Termpaint do
  def process_command("C 1 " <> height) do
    {row_count, _} = Integer.parse(height)
    header = render_header()
    body =
      "| |\n"
      |> List.duplicate(row_count)
      |> Enum.join()
    footer = "---\n"
    Enum.join([header, body, footer])
  end

  defp render_header(), do: "---\n"

end
