# Termpaint

[![svarlet](https://circleci.com/gh/svarlet/termpaint.svg?style=shield)](https://app.circleci.com/pipelines/github/svarlet/termpaint)

## Requirements

1. Elixir 1.10 or above

## Execution

1. Clone this repository
2. Build the project: `cd <PROJECT_PATH>; mix deps.get; mix test; MIX_ENV=PROD mix escript.build`
3. Run it: `./termpaint`
4. Have fun!

## Opinionated implementation

- Creating a 0x0 canvas is considered an error. While it's semantically valid, it's practically absurd: no other command can be performed on a 0x0 canvas (yet?).

- Lines and Rectangles cannot be drawn beyond the boundaries of the canvas. I could have cropped the desired line or rectangle to the possible size. I could also have extended the size of the canvas to fit the line or rectangle. Choosing to treat these as errors is faster and easier to implement.

- Diagonal lines are drawn as a horizontal line *and then* a vertical line. This is important because it means the lines from {1, 1} to {3, 3} and from {3, 3} to {1, 1} are not drawn identically. One will go right and then down, while the other will go left and then up. Interestingly, this means a rectangle can be drawn by drawing one line twice: once with the corners coordinates provided, and one with the swapped coordinates.

## What could be better?

- A command interpreter with parsing rules registered at runtime would make it extensible without recompilation. Yet, compilation is not expensive at this stage, and we are only asked to support a small number of commands. Therefore I consider it would be overengineered at this stage.
