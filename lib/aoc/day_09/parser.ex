defmodule AOC.Day09.Parser do
  @doc ~S"""
  Parse puzzle input.

  The puzzle says it should be one long line, so let's take it at its
  word on that one.

  ## Examples

    iex> AOC.Day09.Parser.parse(["12345\n"]) |> Enum.to_list()
    [{0, 1}, {:empty, 2}, {1, 3}, {:empty, 4}, {2, 5}]
    iex> AOC.Day09.Parser.parse(["2333133121414131402\n"]) |> Enum.to_list()
    [
      {0, 2},
      {:empty, 3},
      {1, 3},
      {:empty, 3},
      {2, 1},
      {:empty, 3},
      {3, 3},
      {:empty, 1},
      {4, 2},
      {:empty, 1},
      {5, 4},
      {:empty, 1},
      {6, 4},
      {:empty, 1},
      {7, 3},
      {:empty, 1},
      {8, 4},
      {9, 2}
    ]
  """
  def parse([input]) do
    String.graphemes(input)
    |> Stream.reject(&(&1 == "\n"))
    |> Stream.with_index()
    |> Stream.map(fn {c, i} ->
      size = String.to_integer(c)

      case rem(i, 2) do
        1 -> {:empty, size}
        0 -> {div(i, 2), size}
      end
    end)
    |> Stream.reject(&is_zero_length?/1)
  end

  defp is_zero_length?({_, 0}), do: true
  defp is_zero_length?(_), do: false
end
