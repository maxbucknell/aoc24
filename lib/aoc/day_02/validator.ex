defmodule AOC.Day02.Validator do
  @increasing 1
  @decreasing -1

  @doc ~S"""
  Given a stream, emit pairs of items.

  ## Examples

    iex> AOC.Day02.Validator.get_pairs([1, 2, 3]) |> Enum.to_list()
    [{1, 2}, {2, 3}]
    iex> AOC.Day02.Validator.get_pairs([16, 17, 18, 21, 23, 24, 27, 24]) |> Enum.to_list()
    [{16, 17}, {17, 18}, {18, 21}, {21, 23}, {23, 24}, {24, 27}, {27, 24}]
  """
  def get_pairs(stream) do
    [head] = Enum.take(stream, 1)
    tail = Enum.slice(stream, 1..-1//1)

    _emit_pairs(head, tail)
  end

  defp _emit_pairs(head, tail) do
    new_tail = Enum.slice(tail, 1..-1//1)

    case Enum.take(tail, 1) do
      [] -> []
      [new_head] -> Stream.concat([{head, new_head}], _emit_pairs(new_head, new_tail))
    end
  end

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
  """
  def is_safe?(levels) do
    pairs = get_pairs(levels)

    [{a, b}] = Enum.take(pairs, 1)

    direction =
      case a > b do
        true -> @decreasing
        _ -> @increasing
      end

    Enum.all?(pairs, &is_pair_safe?(&1, direction))
  end

  @doc ~S"""
  Given a direction, is a pair of levels a safe step?

  ## Examples

    iex> AOC.Day02.Validator.is_pair_safe?({1, 2}, 1)
    true
    iex> AOC.Day02.Validator.is_pair_safe?({2, 7}, 1)
    false
    iex> AOC.Day02.Validator.is_pair_safe?({1, 2}, -1)
    false
  """
  def is_pair_safe?({a, b}, direction) do
    cond do
      a * direction >= b * direction -> false
      abs(b - a) > 3 -> false
      true -> true
    end
  end
end
