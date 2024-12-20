defmodule AOC.Day12.Parser do
  @moduledoc ~S"""
  Parse day 12 puzzle input.

  As usual, we process line-wise, then character-wise. Each region is
  defined by a grapheme, and the first location that is indexed. For
  each new character:

   - We examine it to find its region key
   - We find all of its neighbours
   - We see if there is a region that matches the grapheme that any
     of these neighbours are part of.
   - If yes:
      + We add it to that region, keyed by the index point, which is
        whichever point was added first.
   - If no:
      + We create a new region, and this point becomes the index point.

  This algorithm has a bug! We need to find _all_ regions that any of
  our current node's neighbours are part of, and union them all. We can
  replace them all with the new union, with one of the keys, or our
  point under investigation.

  The parsed data structure is a map of region keys, to maps of index
  points, to sets of points in each region.
  """

  @type point() :: {integer(), integer()}
  @type region() :: MapSet.t(point())
  @type regions() :: %{optional(point()) => region()}
  @type t() :: %{optional(String.t()) => regions()}

  @doc ~S"""
  ## Example

  iex> input = [
  ...>   "AAAA\n",
  ...>   "BBCD\n",
  ...>   "BBCC\n",
  ...>   "EEEC\n",
  ...> ]
  iex> parse(input)
  %{
    "A" => %{
      {3,0} => MapSet.new([{0,0}, {1,0}, {2,0}, {3,0}])
    },
    "B" => %{
      {1, 2} => MapSet.new([{0, 1}, {1, 1}, {0, 2}, {1, 2}])
    },
    "C" => %{
      {3, 3} => MapSet.new([{2, 1}, {2, 2}, {3, 2}, {3, 3}])
    },
    "D" => %{
      {3, 1} => MapSet.new([{3, 1}])
    },
    "E" => %{
      {2, 3} => MapSet.new([{0, 3}, {1, 3}, {2, 3}])
    }
  }

  iex> input = [
  ...>   "OOOOO\n",
  ...>   "OXOXO\n",
  ...>   "OOOOO\n",
  ...>   "OXOXO\n",
  ...>   "OOOOO\n"
  ...> ]
  iex> parse(input)
  %{
    "O" => %{{4, 4} => MapSet.new([{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}, {1, 0}, {1, 2}, {1, 4}, {2, 0}, {2, 1}, {2, 2}, {2, 3}, {2, 4}, {3, 0}, {3, 2}, {3, 4}, {4, 0}, {4, 1}, {4, 2}, {4, 3}, {4, 4}])},
    "X" => %{{1, 1} => MapSet.new([{1, 1}]), {1, 3} => MapSet.new([{1, 3}]), {3, 1} => MapSet.new([{3, 1}]), {3, 3} => MapSet.new([{3, 3}])}
  }

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
  iex> parse(input)
  %{
    "C" => %{
      {5, 6} => MapSet.new([{3, 3}, {4, 3}, {4, 4}, {4, 5}, {5, 2}, {5, 3}, {5, 5}, {5, 6}, {6, 0}, {6, 1}, {6, 2}, {7, 0}, {7, 1}, {8, 1}]),
      {7, 4} => MapSet.new([{7, 4}])
    },
    "E" => %{{9, 9} => MapSet.new([{7, 8}, {7, 9}, {8, 5}, {8, 6}, {8, 7}, {8, 8}, {8, 9}, {9, 4}, {9, 5}, {9, 6}, {9, 7}, {9, 8}, {9, 9}])},
    "F" => %{{8, 4} => MapSet.new([{7, 2}, {7, 3}, {8, 0}, {8, 2}, {8, 3}, {8, 4}, {9, 0}, {9, 1}, {9, 2}, {9, 3}])},
    "I" => %{
      {3, 9} => MapSet.new([{1, 7}, {1, 8}, {2, 5}, {2, 6}, {2, 7}, {2, 8}, {3, 6}, {3, 7}, {3, 8}, {3, 9}, {4, 6}, {4, 7}, {5, 7}, {5, 8}]),
      {5, 1} => MapSet.new([{4, 0}, {4, 1}, {5, 0}, {5, 1}])
    },
    "J" => %{{6, 9} => MapSet.new([{5, 4}, {6, 3}, {6, 4}, {6, 5}, {6, 6}, {6, 7}, {6, 8}, {6, 9}, {7, 5}, {7, 6}, {7, 7}])},
    "M" => %{{2, 9} => MapSet.new([{0, 7}, {0, 8}, {0, 9}, {1, 9}, {2, 9}])},
    "R" => %{{2, 3} => MapSet.new([{0, 0}, {0, 1}, {1, 0}, {1, 1}, {2, 0}, {2, 1}, {2, 2}, {2, 3}, {3, 0}, {3, 1}, {3, 2}, {4, 2}])},
    "S" => %{{5, 9} => MapSet.new([{4, 8}, {4, 9}, {5, 9}])},
    "V" => %{{1, 6} => MapSet.new([{0, 2}, {0, 3}, {0, 4}, {0, 5}, {0, 6}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {2, 4}, {3, 4}, {3, 5}])}
  }
  """
  @spec parse(Enumerable.t(String.t())) :: t()
  def parse(input) do
    Stream.with_index(input)
    |> Enum.reduce(%{}, fn {line, y}, output ->
      parse_line(output, y, line)
    end)
  end

  @spec parse_line(t(), integer(), String.t()) :: t()
  defp parse_line(output, y, line) do
    String.trim(line)
    |> String.graphemes()
    |> Stream.with_index()
    |> Enum.reduce(output, &parse_char(y, &2, &1))
  end

  defp parse_char(y, output, char)

  @spec parse_char(integer(), t(), {String.t(), integer()}) :: t()
  defp parse_char(y, output, {region, x}) do
    point = {x, y}

    Map.get(output, region, %{})
    |> Map.to_list()
    |> Enum.filter(fn {_k, v} -> is_in_region?(point, v) end)
    |> case do
      [] ->
        Map.put_new(output, region, %{})
        |> Map.update!(region, &add_point_to_region(&1, point, point))

      matches ->
        {keys, regions} = Enum.unzip(matches)

        new_region = Enum.reduce(regions, MapSet.new([point]), &MapSet.union/2)

        Map.update!(output, region, fn all ->
          Enum.reduce(keys, all, &Map.delete(&2, &1))
          |> Map.put(point, new_region)
        end)
    end
  end

  @spec is_in_region?(point(), region()) :: boolean()
  defp is_in_region?(point, region) do
    AOC.Utils.Geometry.adjacent_nodes(point)
    |> Enum.any?(&MapSet.member?(region, &1))
  end

  @spec add_point_to_region(regions(), point(), point()) :: regions()
  defp add_point_to_region(regions, key, new_point) do
    Map.update(regions, key, MapSet.new([new_point]), &MapSet.put(&1, new_point))
  end
end
