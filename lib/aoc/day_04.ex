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
        Reader.read_line(line, state)
      end)

    {:ok, count}
  end
end
