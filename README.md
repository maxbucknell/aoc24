# Advent of Code 2024

I'm doing it again this year, or at least, I'm trying to. Elixir has been my
favourite language to start learning ever, so despite the fact that work is
extremely busy, and that I'm in the midst of moving from Australia to Canada,
via The UK, I am cautiously optimistic, and certainly excited!

## Instructions

Every exercise is implemented in `lib/aoc/day_{n}.ex`. Each solution has example code with the supplied test input, which double as unit tests. Run the unit tests like so:

```
mix test
```

Or run a single file like:

```
mix test test/aoc/day_01.exs
```

There is a Mix task that passes stdin to a requested solution, and emits the answer for the supplied input. For example:

```
mix solve 2 b < input/day-2.txt
```
