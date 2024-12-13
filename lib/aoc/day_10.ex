defmodule AOC.Day10 do
  @doc ~S"""
  Day 10, Part A

  ## Example

    iex> input = [
    ...>   "89010123",
    ...>   "78121874",
    ...>   "87430965",
    ...>   "96549874",
    ...>   "45678903",
    ...>   "32019012",
    ...>   "01329801",
    ...>   "10456732"
    ...> ]
    iex> AOC.Day10.a(input)
    {:ok, 36}
  """
  def a(input) do
    {zeros, map} = AOC.Day10.Parser.parse(input)

    result =
      Enum.map(zeros, fn start ->
        AOC.Day10.RoutePlanner.complete_trailheads(map, start)
        |> Enum.uniq()
        |> Enum.count()
      end)
      |> Enum.sum()

    {:ok, result}
  end

  @doc ~S"""
  Day 10, Part B

  ## Example

    iex> input = [
    ...>   "89010123",
    ...>   "78121874",
    ...>   "87430965",
    ...>   "96549874",
    ...>   "45678903",
    ...>   "32019012",
    ...>   "01329801",
    ...>   "10456732"
    ...> ]
    iex> AOC.Day10.b(input)
    {:ok, 81}
  """
  def b(input) do
    {zeros, map} = AOC.Day10.Parser.parse(input)

    result =
      Enum.map(zeros, fn start ->
        AOC.Day10.RoutePlanner.complete_trailheads(map, start)
        |> Enum.count()
      end)
      |> Enum.sum()

    {:ok, result}
  end
end
