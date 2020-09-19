defmodule Termpaint.Parser.Helpers do
  import NimbleParsec

  def positive_int() do
    integer(min: 1)
  end

  def dimensions() do
    positive_int()
    |> ignore(string: " ")
    |> concat(positive_int())
  end

  def coords() do
    positive_int()
    |> ignore(string: " ")
    |> concat(positive_int())
  end

  def canvas_command() do
    string("C")
    |> ignore(string(" "))
    |> concat(dimensions())
    |> eos()
  end

  def draw_line_command() do
    string("L")
    |> ignore(string(" "))
    |> concat(coords())
    |> ignore(string(" "))
    |> concat(coords())
    |> eos()
  end

  def draw_rectangle_command() do
    string("R")
    |> ignore(string(" "))
    |> concat(coords())
    |> ignore(string(" "))
    |> concat(coords())
    |> eos()
  end

  def bucket_fill_command() do
    string("B")
    |> ignore(string(" "))
    |> concat(coords())
    |> ignore(string(" "))
    |> utf8_string([], 1)
    |> eos()
  end

  def quit_command() do
    string("Q")
    |> eos()
  end
end

defmodule Termpaint.Parser do
  import NimbleParsec
  import Termpaint.Parser.Helpers

  defparsec(
    :to_supported_command,
    choice([
      canvas_command(),
      draw_line_command(),
      draw_rectangle_command(),
      bucket_fill_command(),
      quit_command()
    ])
  )
end
