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

- Commands are implemented with [Protocols](https://elixir-lang.org/getting-started/protocols.html). This enables the definition of new commands without altering any other module. Indeed, we could add a command to draw a cross *by adding new code instead of modifying existing code*. This is the O of SOLID.

- The command parser is built with [parser combinators](https://en.wikipedia.org/wiki/Parser_combinator), so it's extremely easy to change. Given a new command to support, the parser would need only a few *additional* lines to accept it. This is in stark comparison to a regex or handmade string manipulation approach which would likely be harder to change. A question remains: how could we make the parser extensible without recompilation? Surely, there is a way to leverage protocols like I did for the application of commands to the canvas (see point above).


## What could be better?

- A command interpreter with parsing rules registered at runtime would make it extensible without recompilation. Yet, compilation is not expensive at this stage, and we are only asked to support a small number of commands. Therefore I consider it would be overengineered at this stage.

- The bucket fill command is only effective on pristine areas of the canvas. This is something I realised quite late, and surely this could be changed easily: perhaps "anything but the X character" would be a way to fix this while sticking to the usual behaviour of bucket-fill in paint programs.

- Error handling is done well, but does not print an error explanation to the user (or should I say artist?). It just skips the command. Again, the error are customized according to the context, adding a little more contextual information to them is trivial, and formatting+displaying them is easy as well.

- Rendering relies on Elixir IO Lists, which are [known for delivering incredible performance](https://nerdranchighq.wpengine.com/blog/elixir-and-io-lists-part-1-building-output-efficiently/) by avoiding many string concatenations and by relying on low level optimizations provided by the Beam VM. Yet, there are still a number of operations happening on Lists of pixels so the performance could probably be improved. My thought would be to use a Stream which would be extremely efficient memory wise, at the cost of CPU efficiency. The user would certainly enjoy a rendering starting earlier though (the good old "Perceived performance VS Actual performance"). As is, the program has been tested successfully with a 10k x 10k canvas (100M pixels!). 
