defmodule AOC.Day12 do
  @doc ~S"""
  Day 12, Part A

  ## Example

    iex> input = [
    ...>   "RRRRIICCFF\n",
    ...>   "RRRRIICCCF\n",
    ...>   "VVRRRCCFFF\n",
    ...>   "VVRCCCJFFF\n",
    ...>   "VVVVCJJCFE\n",
    ...>   "VVIVCCJJEE\n",
    ...>   "VVIIICJJEE\n",
    ...>   "MIIIIIJJEE\n",
    ...>   "MIIISIJEEE\n",
    ...>   "MMMISSJEEE\n"
    ...> ]
    iex> a(input)
    {:ok, 1930}
  """
  @spec a(Enumerable.t(String.t())) :: {:ok, integer()} | {:error, atom()}
  def a(input) do
    parsed = AOC.Day12.Parser.parse(input)

    result =
      parsed
      |> Map.to_list()
      |> Stream.flat_map(fn {k, regions} -> Map.values(regions) |> Enum.map(&{k, &1}) end)
      |> Stream.map(fn {_k, region} ->
        area = AOC.Day12.Metrics.area(region)
        perimeter = AOC.Day12.Metrics.perimeter(region)

        _price = area * perimeter
      end)
      |> Enum.sum()

    {:ok, result}
  end
end
