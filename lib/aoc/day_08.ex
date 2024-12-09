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
        AOC.Day08.Combinator.find_combinations(locations)
      end)
      |> Enum.flat_map(fn {a, b} ->
        AOC.Day08.Antinodes.find_antinodes(a, b)
      end)
      |> Enum.filter(&AOC.Day08.Antinodes.is_valid?({width, height}, &1))
      |> MapSet.new()
      |> MapSet.size()

    {:ok, result}
  end

  @doc ~S"""
  Day 8, Part B

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
    iex> AOC.Day08.b(input)
    {:ok, 34}
  """
  def b(input) do
    %{width: width, height: height, locations: locations} =
      AOC.Day08.Parser.parse(input)

    result =
      locations
      |> Map.to_list()
      |> Enum.flat_map(fn {_frequency, locations} ->
        AOC.Day08.Combinator.find_combinations(locations)
      end)
      |> Enum.flat_map(fn {a, b} ->
        AOC.Day08.Antinodes.find_all_along_line({width, height}, a, b)
      end)
      |> Enum.filter(&AOC.Day08.Antinodes.is_valid?({width, height}, &1))
      |> MapSet.new()
      |> MapSet.size()

    {:ok, result}
  end
end
