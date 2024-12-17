defmodule AOC.Utils.Enum do
  @moduledoc ~S"""
  Functions on lists and streams that I've needed through AoC.

  Things that are generic enough that they make it out of the
  individual solutions. Generally speaking, if I need something
  twice, I move it out here.
  """

  @type point() :: {integer(), integer()}

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
end
