defmodule AOC.Day06 do
  @doc ~S"""
  Day 6, Part A

  ## Example

    iex> input = [
    ...>   "....#.....",
    ...>   ".........#",
    ...>   "..........",
    ...>   "..#.......",
    ...>   ".......#..",
    ...>   "..........",
    ...>   ".#..^.....",
    ...>   "........#.",
    ...>   "#.........",
    ...>   "......#...",
    ...> ]
    iex> AOC.Day06.a(input)
    {:ok, 41}
  """
  def a(input) do
    {room, guard} = AOC.Day06.Parser.parse(input)

    visited_nodes = AOC.Day06.Guard.plan(room, guard)

    {:ok, MapSet.size(visited_nodes)}
  end

  @doc ~S"""
  Day 6, Part B

  ## Example

    iex> input = [
    ...>   "....#.....",
    ...>   ".........#",
    ...>   "..........",
    ...>   "..#.......",
    ...>   ".......#..",
    ...>   "..........",
    ...>   ".#..^.....",
    ...>   "........#.",
    ...>   "#.........",
    ...>   "......#...",
    ...> ]
    iex> AOC.Day06.b(input)
    {:ok, 6}
  """
  def b(input) do
    {room, guard} = AOC.Day06.Parser.parse(input)

    loops = AOC.Day06.Guard.find_potential_loops(room, guard)

    {:ok, MapSet.size(loops)}
  end
end
