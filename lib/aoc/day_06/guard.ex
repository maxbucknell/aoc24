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

  def find_potential_loops(room, guard, loops \\ MapSet.new(), not_loops \\ MapSet.new()) do
    {_, _, direction} = guard
    obstacle = Room.next_obstacle(room, guard)
    # Discard the first location, since that is where the guard currently is!
    {{dx, dy}, [_ | path]} = Room.move_to_obstacle(room, obstacle, guard)

    {new_loops, not_loops} =
      Enum.reduce(path, {MapSet.new(), not_loops}, fn {x, y}, {loops, not_loops} ->
        hypothetical_room = Room.add_obstacle(room, x, y)

        cond do
          MapSet.member?(not_loops, {x, y}) -> {loops, not_loops}
          will_loop?(hypothetical_room, guard) -> {MapSet.put(loops, {x, y}), not_loops}
          true -> {loops, MapSet.put(not_loops, {x, y})}
        end
      end)

    loops = MapSet.union(loops, new_loops)

    if obstacle == nil do
      loops
    else
      find_potential_loops(room, {dx, dy, rotate(direction)}, loops, not_loops)
    end
  end

  def will_loop?(room, guard, previous \\ []) do
    obstacle = Room.next_obstacle(room, guard)

    if obstacle == nil do
      # We escaped!
      false
    else
      {_, _, direction} = guard
      {{dx, dy}, _} = Room.move_to_obstacle(room, obstacle, guard)
      new_guard = {dx, dy, rotate(direction)}

      case new_guard in previous do
        true ->
          true

        false ->
          will_loop?(room, new_guard, [new_guard | previous])
      end
    end
  end

  defp rotate(:up), do: :right
  defp rotate(:right), do: :down
  defp rotate(:down), do: :left
  defp rotate(:left), do: :up
end
