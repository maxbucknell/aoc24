defmodule AOC.Day18.Space do
  @enforce_keys [:width, :height]
  defstruct [:width, :height, obstacles: MapSet.new()]

  def navigate(space, start, finish) do
    distances =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while(
        {[start], %{start => 0}},
        fn level, {points, distances} ->
          case points do
            [] ->
              {:halt, distances}

            points ->
              {new_points, distances} =
                Stream.flat_map(points, &AOC.Utils.Geometry.adjacent_nodes/1)
                |> Stream.uniq()
                |> Stream.reject(fn new_point ->
                  MapSet.member?(space.obstacles, new_point) or
                    AOC.Utils.Geometry.out_of_bounds?(
                      space.width,
                      space.height,
                      new_point
                    ) or
                    Map.has_key?(distances, new_point)
                end)
                |> Enum.map_reduce(distances, &{&1, Map.put_new(&2, &1, level)})

              if Map.has_key?(distances, finish) do
                {:halt, distances}
              else
                {:cont, {new_points, distances}}
              end
          end
        end
      )

    Map.get(distances, finish, :infinity)
  end
end
