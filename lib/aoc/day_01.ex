defmodule AOC.Day01 do
  @doc ~S"""
  Solution to Day 1, Part 1

  See [question here](https://adventofcode.com/2024/day/1)

  ## Examples

    iex> input = [
    ...>   "3   4",
    ...>   "4   3",
    ...>   "2   5",
    ...>   "1   3",
    ...>   "3   9",
    ...>   "3   3",
    ...> ]
    iex> AOC.Day01.a(input)
    {:ok, 11}
  """
  def a(input) do
    {left, right} = AOC.Day01.Parser.parse_input(input)

    left = Enum.sort(left)
    right = Enum.sort(right)

    result =
      Stream.zip([left, right])
      |> Stream.map(fn {a, b} -> abs(a - b) end)
      |> Enum.sum()

    {:ok, result}
  end

  @doc ~S"""
  Solution to Day 1, Part 2

  See [question here](https://adventofcode.com/2024/day/1)

  ## Examples

    iex> input = [
    ...>   "3   4",
    ...>   "4   3",
    ...>   "2   5",
    ...>   "1   3",
    ...>   "3   9",
    ...>   "3   3",
    ...> ]
    iex> AOC.Day01.b(input)
    {:ok, 31}
  """
  def b(input) do
    {left, right} = AOC.Day01.Parser.parse_input(input)

    occurrences =
      right
      |> Enum.reduce(%{}, fn n, acc -> Map.update(acc, n, 1, &(&1 + 1)) end)

    result =
      left
      |> Enum.map(fn n -> n * Map.get(occurrences, n, 0) end)
      |> Enum.sum()

    {:ok, result}
  end
end
