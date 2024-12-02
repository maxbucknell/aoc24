defmodule AOC.Day02 do
  @doc ~S"""
  Solve Day 2, Part A.

  See https://adventofcode.com/2024/day/2

  ## Examples

    iex> input = [
    ...>   "7 6 4 2 1",
    ...>   "1 2 7 8 9",
    ...>   "9 7 6 2 1",
    ...>   "1 3 2 4 5",
    ...>   "8 6 4 4 1",
    ...>   "1 3 6 7 9"
    ...> ]
    iex> AOC.Day02.a(input)
    {:ok, 2}
  """
  def a(input) do
    result =
      input
      |> Stream.map(&AOC.Day02.Parser.parse_line(&1))
      |> Stream.filter(&AOC.Day02.Validator.is_safe?(&1))
      |> Enum.count()

    {:ok, result}
  end

  @doc ~S"""
  Solve Day 2, Part B.

  See above

  ## Examples

    iex> input = [
    ...>   "7 6 4 2 1",
    ...>   "1 2 7 8 9",
    ...>   "9 7 6 2 1",
    ...>   "1 3 2 4 5",
    ...>   "8 6 4 4 1",
    ...>   "1 3 6 7 9"
    ...> ]
    iex> AOC.Day02.b(input)
    {:ok, 4}
  """
  def b(input) do
    result =
      input
      |> Stream.map(&AOC.Day02.Parser.parse_line(&1))
      |> Stream.filter(&AOC.Day02.Validator.is_safe?(&1, 1))
      |> Enum.count()

    {:ok, result}
  end
end
