defmodule AOC.Day12.Metrics do
  @moduledoc ~S"""
  Derive perimeters and areas of regions.
  """

  @doc ~S"""
  The area of a region is simply the number of points contained within.
  """
  @spec area(AOC.Day12.Parser.region()) :: integer()
  def area(region) do
    MapSet.size(region)
  end

  @doc ~S"""
  The perimeter is calculated per point.

  For any given point, its contribution to the region's perimeter is:
  four minus the number of neighbours that are also in the region.

  ## Examples

    iex> region = MapSet.new([{0, 0}])
    iex> perimeter(region)
    4
    iex> region = MapSet.new([{0, 0}, {0, 1}])
    iex> perimeter(region)
    6
    iex> region = MapSet.new([{0, 0}, {0, 1}, {1, 1}, {1, 0}])
    iex> perimeter(region)
    8
    iex> region = MapSet.new([{0, 0}, {0, 1}, {1, 1}, {1, 2}])
    iex> perimeter(region)
    10
  """
  @spec perimeter(AOC.Day12.Parser.region()) :: integer()
  def perimeter(region) do
    MapSet.to_list(region)
    |> Stream.map(&perimeter_of_point(region, &1))
    |> Enum.sum()
  end

  defp perimeter_of_point(region, point) do
    neighbours_in_set =
      AOC.Utils.Geometry.adjacent_nodes(point)
      |> Enum.count(&MapSet.member?(region, &1))

    4 - neighbours_in_set
  end
end
