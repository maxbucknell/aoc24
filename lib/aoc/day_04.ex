defmodule AOC.Day04 do
  alias AOC.Day04.Reader

  @doc ~S"""
  Solve Day 4, Part A

  ## Example

    iex> input = [
    ...>   "MMMSXXMASM",
    ...>   "MSAMXMSMSA",
    ...>   "AMXSXMAAMM",
    ...>   "MSAMASMSMX",
    ...>   "XMASAMXAMM",
    ...>   "XXAMMXXAMA",
    ...>   "SMSMSASXSS",
    ...>   "SAXAMASAAA",
    ...>   "MAMMMXMMMM",
    ...>   "MXMXAXMASX",
    ...>   ]
    iex> AOC.Day04.a(input)
    {:ok, 18}
  """
  def a(input) do
    %{count: count} =
      Enum.reduce(input, %{}, fn line, state ->
        Reader.A.read_line(line, state)
      end)

    {:ok, count}
  end

  @doc ~S"""
  Solve Day 4, Part A

  ## Example

    iex> input = [
    ...>   "MMMSXXMASM",
    ...>   "MSAMXMSMSA",
    ...>   "AMXSXMAAMM",
    ...>   "MSAMASMSMX",
    ...>   "XMASAMXAMM",
    ...>   "XXAMMXXAMA",
    ...>   "SMSMSASXSS",
    ...>   "SAXAMASAAA",
    ...>   "MAMMMXMMMM",
    ...>   "MXMXAXMASX",
    ...>   ]
    iex> AOC.Day04.b(input)
    {:ok, 18}
  """
  def b(_) do
    {:error, :not_implemented_yet}
  end
end
