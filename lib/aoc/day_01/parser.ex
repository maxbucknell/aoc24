defmodule AOC.Day01.Parser do
  @doc ~S"""
  Parse a stream into two tuples, left and right.

  ### Examples

    iex> input = [
    ...>   "3   4",
    ...>   "4   3",
    ...>   "2   5",
    ...>   "1   3",
    ...>   "3   9",
    ...>   "3   3",
    ...> ]
    iex> AOC.Day01.Parser.parse_input(input)
    {[3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3]}
  """
  def parse_input(input) do
    input
    |> Stream.map(fn line ->
      {:ok, output} = AOC.Day01.Parser.parse_line(line)

      output
    end)
    |> Enum.unzip()
  end

  @doc ~S"""
  Parse a single line of Day 1 input.

  ## Examples

    iex> AOC.Day01.Parser.parse_line("3   4")
    {:ok, {3, 4}}

    iex> AOC.Day01.Parser.parse_line("4   3")
    {:ok, {4, 3}}

    iex> AOC.Day01.Parser.parse_line("69214   60950")
    {:ok, {69214, 60950}}
  """
  def parse_line(line) do
    with [left, right] <- String.split(line),
         {left, ""} <- Integer.parse(left, 10),
         {right, ""} <- Integer.parse(right, 10) do
      {:ok, {left, right}}
    else
      _ -> {:error, :invalid_line, line}
    end
  end
end
