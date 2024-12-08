defmodule AOC.Day07 do
  @doc ~S"""
  Day 7, Part A

  ## Example

    iex> input = [
    ...>   "190: 10 19",
    ...>   "3267: 81 40 27",
    ...>   "83: 17 5",
    ...>   "156: 15 6",
    ...>   "7290: 6 8 6 15",
    ...>   "161011: 16 10 13",
    ...>   "192: 17 8 14",
    ...>   "21037: 9 7 18 13",
    ...>   "292: 11 6 16 20",
    ...> ]
    iex> AOC.Day07.a(input)
    {:ok, 3749}
  """
  def a(input) do
    result =
      AOC.Day07.Parser.parse(input)
      |> Stream.filter(&AOC.Day07.Solver.A.has_solution?/1)
      |> Enum.reduce(0, fn {target, _}, sum -> sum + target end)

    {:ok, result}
  end

  @doc ~S"""
  Day 7, Part B

  ## Example

    iex> input = [
    ...>   "190: 10 19",
    ...>   "3267: 81 40 27",
    ...>   "83: 17 5",
    ...>   "156: 15 6",
    ...>   "7290: 6 8 6 15",
    ...>   "161011: 16 10 13",
    ...>   "192: 17 8 14",
    ...>   "21037: 9 7 18 13",
    ...>   "292: 11 6 16 20",
    ...> ]
    iex> AOC.Day07.b(input)
    {:ok, 11387}
  """
  def b(input) do
    result =
      AOC.Day07.Parser.parse(input)
      |> Stream.filter(&AOC.Day07.Solver.B.has_solution?/1)
      |> Enum.reduce(0, fn {target, _}, sum -> sum + target end)

    {:ok, result}
  end
end
