defmodule AOC.Day10.RoutePlanner do
  @doc ~S"""
  Find neighbours at the desired height.

  ## Example

    iex> map = %{
    ...>   {0,0} => 4,
    ...>   {1,0} => 2,
    ...>   {0,1} => 1,
    ...>   {1,1} => 3
    ...> }
    iex> AOC.Day10.RoutePlanner.find(map, {0,1}, 3)
    [{1,1}]
  """
  def find(map, node, target) do
    AOC.Utils.Enum.adjacent_nodes(node)
    |> Enum.filter(fn neighbour -> Map.get(map, neighbour) == target end)
  end

  def complete_trailheads(map, start) do
    complete_trailheads(map, start, 1)
  end

  def complete_trailheads(_, start, 10) do
    [start]
  end

  def complete_trailheads(map, start, target) do
    find(map, start, target)
    |> Enum.flat_map(fn next ->
      complete_trailheads(map, next, target + 1)
    end)
  end
end
