defmodule AOC.Day02.Validator do
  alias AOC.Day02.Reactor

  @doc ~S"""
  Validate a stream of numeric levels as per the exercise

  https://adventofcode.com/2024/day/2

  ## Examples

    iex> AOC.Day02.Validator.is_safe?([7, 6, 4, 2, 1])
    true
    iex> AOC.Day02.Validator.is_safe?([1, 2, 7, 8, 9])
    false
    iex> AOC.Day02.Validator.is_safe?([9, 7, 6, 2, 1])
    false
    iex> AOC.Day02.Validator.is_safe?([1, 3, 2, 4, 5])
    false
    iex> AOC.Day02.Validator.is_safe?([8, 6, 4, 4, 1])
    false
    iex> AOC.Day02.Validator.is_safe?([1, 3, 6, 7, 9])
    true
    iex> AOC.Day02.Validator.is_safe?([7, 6, 4, 2, 1], 1)
    true
    iex> AOC.Day02.Validator.is_safe?([1, 2, 7, 8, 9], 1)
    false
    iex> AOC.Day02.Validator.is_safe?([9, 7, 6, 2, 1], 1)
    false
    iex> AOC.Day02.Validator.is_safe?([1, 3, 2, 4, 5], 1)
    true
    iex> AOC.Day02.Validator.is_safe?([8, 6, 4, 4, 1], 1)
    true
    iex> AOC.Day02.Validator.is_safe?([1, 3, 6, 7, 9], 1)
    true
  """
  def is_safe?(levels, dampener \\ 0) do
    levels
    |> Enum.reduce_while(Reactor.new(dampener), fn level, reactor ->
      case Reactor.register(reactor, level) do
        {:ok, reactor} -> {:cont, reactor}
        {:error, _} -> {:halt, :error}
      end
    end)
    |> case do
      :error -> false
      _ -> true
    end
  end
end
