defmodule AOC.Day06.GuardTest do
  use ExUnit.Case, async: true

  alias AOC.Day06.Guard

  test "Basic loop" do
    input = [
      ".#..",
      ">..#",
      "#...",
      "..#."
    ]

    {room, guard} = AOC.Day06.Parser.parse(input)

    assert Guard.will_loop?(room, guard)
  end

  test "Check for false positives" do
    input = [
      "......v.",
      "..#.....",
      "....#..#",
      "........",
      "........",
      ".#......",
      "......#.",
      "........"
    ]

    {room, guard} = AOC.Day06.Parser.parse(input)

    assert not Guard.will_loop?(room, guard)
  end
end
