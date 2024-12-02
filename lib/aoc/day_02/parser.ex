defmodule AOC.Day02.Parser do
  @doc ~S"""
  Given a string of space-separated numbers, emit a stream of numbers.

  ## Examples

    iex> AOC.Day02.Parser.parse_line("7 6 4 2 1") |> Enum.to_list()
    [7, 6, 4, 2, 1]
    iex> AOC.Day02.Parser.parse_line("16 17 18 21 23 24 27 24") |> Enum.to_list()
    [16, 17, 18, 21, 23, 24, 27, 24]
  """
  def parse_line(line) do
    String.split(line) |> Stream.map(&String.to_integer(&1, 10))
  end
end
