defmodule AOC.Day07.Parser do
  @doc ~S"""
  Parse puzzle input.

  ## Examples

    iex> input = [
    ...>   "190: 10 19\n",
    ...>   "3267: 81 40 27\n",
    ...>   "83: 17 5\n",
    ...>   "156: 15 6\n"
    ...> ]
    iex> AOC.Day07.Parser.parse(input) |> Enum.to_list()
    [
      {190, [19, 10]},
      {3267, [27, 40, 81]},
      {83, [5, 17]},
      {156, [6, 15]}
    ]
  """
  def parse(input) do
    Stream.map(input, &parse_line/1)
  end

  @doc ~S"""
  Parse a line of puzzle input

  ## Examples

    iex> AOC.Day07.Parser.parse_line("190: 10 19\n")
    {190, [19, 10]}
    iex> AOC.Day07.Parser.parse_line("21037: 9 7 18 13\n")
    {21037, [13, 18, 7, 9]}
  """
  def parse_line(line) do
    [sum | parts] =
      String.split(line, ~r[:|\s], trim: true)
      |> Enum.map(&String.to_integer/1)

    {sum, Enum.reverse(parts)}
  end
end
