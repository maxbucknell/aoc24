defmodule AOC.Day08 do
  @doc ~S"""
  Day 8, Part A

  ## Example

    iex> input = [
    ...>   "............\n",
    ...>   "........0...\n",
    ...>   ".....0......\n",
    ...>   ".......0....\n",
    ...>   "....0.......\n",
    ...>   "......A.....\n",
    ...>   "............\n",
    ...>   "............\n",
    ...>   "........A...\n",
    ...>   ".........A..\n",
    ...>   "............\n",
    ...>   "............\n",
    ...> ]
    iex> AOC.Day08.a(input)
    {:ok, 14}

  """
  def a(input) do
    %{width: width, height: height, locations: locations} =
      AOC.Day08.Parser.parse(input)

    result =
      locations
      |> Map.to_list()
      |> Enum.flat_map(fn {_frequency, locations} ->
        Enum.flat_map(locations, fn {x, y} = outer ->
          Enum.flat_map(locations, fn {p, q} = inner ->
            if outer == inner do
              []
            else
              [
                {x + x - p, y + y - q},
                {p + p - x, q + q - y}
              ]
              |> Enum.reject(fn {a, b} -> a < 0 or a >= width or b < 0 or b >= height end)
            end
          end)
        end)
      end)
      |> MapSet.new()
      |> MapSet.size()

    {:ok, result}
  end
end
