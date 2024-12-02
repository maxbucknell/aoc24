defmodule AOC.Day01.Parser do
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
