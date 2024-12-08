defmodule AOC.Day06.Guard do
  alias AOC.Day06.Room

  def plan(room, guard, route \\ MapSet.new()) do
    {_, _, direction} = guard
    obstacle = Room.next_obstacle(room, guard)
    {{x, y}, visited} = Room.move_to_obstacle(room, obstacle, guard)

    new_route = MapSet.union(route, MapSet.new(visited))

    if obstacle == nil do
      new_route
    else
      plan(room, {x, y, rotate(direction)}, new_route)
    end
  end

  def find_potential_loops(room, guard, loops \\ MapSet.new()) do
    {_, _, direction} = guard
    obstacle = Room.next_obstacle(room, guard)
    {{dx, dy}, path} = Room.move_to_obstacle(room, obstacle, guard)

    new_loops =
      Enum.reduce(path, MapSet.new(), fn {x, y}, loops ->
        room = Room.add_obstacle(room, x, y)

        if will_loop?(room, guard) do
          MapSet.put(loops, {x, y})
        else
          loops
        end
      end)

    loops = MapSet.union(loops, new_loops)

    if obstacle == nil do
      loops
    else
      find_potential_loops(room, {dx, dy, rotate(direction)}, loops)
    end
  end

  def will_loop?(room, guard) do
    obstacle = Room.next_obstacle(room, guard)
    {{dx, dy}, _} = Room.move_to_obstacle(room, obstacle, guard)
    {_, _, direction} = guard

    guard = {dx, dy, rotate(direction)}

    {gx, gy, _} =
      1..4
      |> Enum.reduce(guard, fn _, guard ->
        obstacle = Room.next_obstacle(room, guard)
        {_, _, direction} = guard
        {{dx, dy}, _} = Room.move_to_obstacle(room, obstacle, guard)

        {dx, dy, rotate(direction)}
      end)

    gx == dx and gy == dy
  end

  defp rotate(:up), do: :right
  defp rotate(:right), do: :down
  defp rotate(:down), do: :left
  defp rotate(:left), do: :up
end
