defmodule AOC.Day06.ParserTest do
  use ExUnit.Case, async: true

  alias AOC.Day06.Parser
  alias AOC.Day06.Room

  test "Creation of basic state" do
    input = [
      "..",
      "^."
    ]

    actual = Parser.parse(input)

    expected = {
      %Room{
        width: 2,
        height: 2,
        rows: %{},
        cols: %{}
      },
      {0, 1, :up}
    }

    assert actual == expected
  end

  test "Finds obstacles" do
    input = [
      ".#",
      "^."
    ]

    actual = Parser.parse(input)

    expected = {
      %Room{
        width: 2,
        height: 2,
        rows: %{
          0 => [1]
        },
        cols: %{
          1 => [0]
        }
      },
      {0, 1, :up}
    }

    assert actual == expected
  end

  test "Test input" do
    input = [
      "....#.....",
      ".........#",
      "..........",
      "..#.......",
      ".......#..",
      "..........",
      ".#..^.....",
      "........#.",
      "#.........",
      "......#..."
    ]

    actual = Parser.parse(input)

    expected = {
      %Room{
        width: 10,
        height: 10,
        rows: %{
          0 => [4],
          1 => [9],
          3 => [2],
          4 => [7],
          6 => [1],
          7 => [8],
          8 => [0],
          9 => [6]
        },
        cols: %{
          0 => [8],
          1 => [6],
          2 => [3],
          4 => [0],
          6 => [9],
          7 => [4],
          8 => [7],
          9 => [1]
        }
      },
      {4, 6, :up}
    }

    assert actual == expected
  end
end
