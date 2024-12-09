defmodule AOC.Day08.Combinator do
  @doc ~S"""
  Generate all combinations of two elements of a list.

  ## Examples

    iex> AOC.Day08.Combinator.find_combinations([1, 2, 3]) |> Enum.to_list()
    [{1, 2}, {1, 3}, {2, 3}]
    iex> AOC.Day08.Combinator.find_combinations([1, 2, 3, 4]) |> Enum.to_list()
    [{1, 2}, {1, 3}, {1, 4}, {2, 3}, {2, 4}, {3, 4}]
  """
  def find_combinations([head | tail]) do
    Stream.map(tail, &{head, &1})
    |> Stream.concat(find_combinations(tail))
  end

  def find_combinations([]), do: []
end
