# Termpaint

[![svarlet](https://circleci.com/gh/svarlet/termpaint.svg?style=shield)](https://app.circleci.com/pipelines/github/svarlet/termpaint)

## Requirements

1. Elixir 1.10 or above

## Execution

1. Clone this repository
2. Build the project: `cd <PROJECT_PATH>; mix deps.get; mix test; MIX_ENV=PROD mix escript.build`
3. Run it: `./termpaint`
4. Have fun!

## Important Note

This code test was provided at **extreme short notice and achieved in a few hours**, thus has severe limitations which I would address if my schedule allowed it:
- It lacks an exhaustive error handling with regards to user inputs
- Its performance gets really bad beyond a 1k x 1k canvas due to an effective yet poor rendering algorithm

Notable errors that should be handled gracefully:
- unsupported command
- missing command argument
- invalid type for a command argument
- valid command argument but outside of canvas bounds

I chose not to support a 0x0 canvas. I appreciate it's debatable: what's wrong with the following?
```
--
||
--
```
Nothing, but a user won't be able to do anything in it, so I exploited the lack of clarity of the code test with regard to this edge case.

## What could be better?

While I'm happy with the core modules like Canvas and Renderer, there are a few things I wish I had done better.

First, the adapter layer, namely the termpaint module could be less coupled to the other modules or to the std library. Essentially, I should invert some dependencies. Instead of making it depend on the IO module, the Renderer module, and the Parser module, these could be configured and wired in main() and provided as a configuration argument.

Second, and strongly related to the previous point, there are not enough tests testing the collaboration between the Termpoint module and its dependencies. This results in [a lot of contract tests and too few collaboration tests](https://blog.thecodewhisperer.com/permalink/integrated-tests-are-a-scam).

Third, I appreciate the honourable-reviewer-of-the-test may not have Elixir installed on their computer and wish I had provided a docker file to help their inner artist reveal themselves.

