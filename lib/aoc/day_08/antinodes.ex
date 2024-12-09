defmodule AOC.Day08.Antinodes do
  @doc ~S"""
  Find antinodes between two locations.

  ## Examples

    iex> AOC.Day08.Antinodes.find_antinodes({0, 0}, {0, 0})
    []
    iex> AOC.Day08.Antinodes.find_antinodes({0, 0}, {0, 1})
    [{0, -1}, {0, 2}]
    iex> AOC.Day08.Antinodes.find_antinodes({1, 1}, {3, 3})
    [{-1, -1}, {5, 5}]
    iex> AOC.Day08.Antinodes.find_antinodes({14, 19}, {18, 20})
    [{10, 18}, {22, 21}]
  """
  def find_antinodes(a, a), do: []

  def find_antinodes(a, b) do
    [
      project_one_step(a, b),
      project_one_step(b, a)
    ]
  end

  def find_all_along_line(_, a, a), do: []

  @doc ~S"""
  Given two points, project along them to find every point in line, within bounds.

  ## Examples

  iex> AOC.Day08.Antinodes.find_all_along_line({10, 10}, {4, 4}, {8, 8})
  ...>   |> Enum.to_list()
  [{4, 4}, {5, 5}, {6, 6}, {7, 7}, {8, 8}, {9, 9}, {3, 3}, {2, 2}, {1, 1}, {0, 0}]
  iex> AOC.Day08.Antinodes.find_all_along_line({8, 9}, {2, 4}, {3, 7})
  ...>   |> Enum.to_list()
  [{2, 4}, {3, 7}, {1, 1}]
  """
  def find_all_along_line(bounds, a, b) do
    step = find_minimal_step(a, b)

    # Start at origin
    [a]
    # Then go forwards
    |> Stream.concat(project(bounds, a, step))
    # And backwards
    |> Stream.concat(project(bounds, a, multiply(step, -1)))
  end

  defp project(bounds, a, step) do
    candidate = add(a, step)

    if is_valid?(bounds, candidate) do
      [candidate | project(bounds, candidate, step)]
    else
      []
    end
  end

  def is_valid?({width, height}, {x, y}) do
    0 <= x and x < width and
      0 <= y and y < height
  end

  defp multiply({x, y}, factor) do
    {x * factor, y * factor}
  end

  defp add({x, y}, {dx, dy}) do
    {x + dx, y + dy}
  end

  @doc ~S"""
  Given two points, find the minimal integer step between them.

  ## Examples

    iex> AOC.Day08.Antinodes.find_minimal_step({0, 0}, {1, 1})
    {1, 1}
    iex> AOC.Day08.Antinodes.find_minimal_step({0, 0}, {5, 5})
    {1, 1}
    iex> AOC.Day08.Antinodes.find_minimal_step({3, 5}, {5, 5})
    {1, 0}
    iex> AOC.Day08.Antinodes.find_minimal_step({12, 13}, {8, 17})
    {-1, 1}
    iex> AOC.Day08.Antinodes.find_minimal_step({12, 13}, {18, 21})
    {3, 4}
  """
  def find_minimal_step({x1, y1}, {x2, y2}) do
    dx = x2 - x1
    dy = y2 - y1

    factor = Integer.gcd(dy, dx)

    {div(dx, factor), div(dy, factor)}
  end

  defp project_one_step({x, y}, {dx, dy}) do
    {2 * x - dx, 2 * y - dy}
  end
end
