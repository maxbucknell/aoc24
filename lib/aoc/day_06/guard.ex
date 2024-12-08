defmodule AOC.Day06.Guard do
  alias AOC.Day06.Room

  def plan(room, guard, route \\ MapSet.new()) do
    {_, _, direction} = guard
    obstacle = Room.next_obstacle(room, guard)
    {{x, y}, visited} = Room.move_to_obstacle(room, obstacle, guard)

    new_route = MapSet.union(route, visited)

    if obstacle == nil do
      new_route
    else
      plan(room, {x, y, rotate(direction)}, new_route)
    end
  end

  def rotate(:up), do: :right
  def rotate(:right), do: :down
  def rotate(:down), do: :left
  def rotate(:left), do: :up
end
