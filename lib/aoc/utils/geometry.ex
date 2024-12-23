defmodule AOC.Utils.Geometry do
  @moduledoc ~S"""
  Functions on lists and streams that I've needed through AoC.

  Things that are generic enough that they make it out of the
  individual solutions. Generally speaking, if I need something
  twice, I move it out here.
  """

  @type point() :: {integer(), integer()}
  @type direction() :: :up | :right | :down | :left

  @doc ~S"""
  Given a point {x, y}, list its adjacent nodes.

  This does not include diagonal connections. Proceeds clockwise,
  starting above.

  ## Examples

    iex> adjacent_nodes({0, 0})
    [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
  """
  @spec adjacent_nodes(point()) :: [point()]
  def adjacent_nodes(point)

  def adjacent_nodes({x, y}) do
    [{x, y - 1}, {x + 1, y}, {x, y + 1}, {x - 1, y}]
  end

  @doc ~S"""
  Given a point {x, y}, get its neighbour in a given direction.

  ## Examples

    iex> neighbour({0, 0}, :down)
    {0, 1}
    iex> neighbour({41, 3}, :left)
    {40, 3}
  """
  @spec neighbour(point(), direction()) :: point()
  def neighbour({x, y}, :up), do: {x, y - 1}
  def neighbour({x, y}, :right), do: {x + 1, y}
  def neighbour({x, y}, :down), do: {x, y + 1}
  def neighbour({x, y}, :left), do: {x - 1, y}

  def largest({x1, y1}, {x2, y2}) do
    {max(x1, x2), max(y1, y2)}
  end
end
