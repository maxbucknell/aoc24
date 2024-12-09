defmodule AOC.Day03 do
  alias AOC.Day03.Parser

  @doc ~S"""
    iex> input = [
    ...>   "xmul(2,4)%&mul[3,\n",
    ...>   "7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))\n"
    ...> ]
    iex> AOC.Day03.a(input)
    {:ok, 161}
  """
  def a(input) do
    result =
      Stream.concat(Stream.map(input, &String.graphemes/1))
      |> Enum.reduce({[], nil}, fn x, {vals, state} ->
        case Parser.A.parse(state, x) do
          {:val, n} -> {vals ++ [n], nil}
          new_state -> {vals, new_state}
        end
      end)
      |> (fn {vals, _} -> vals end).()
      |> Enum.sum()

    {:ok, result}
  end

  @doc ~S"""
    iex> input = [
    ...>   "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)\n",
    ...>   "+mul(32,64](mul(11,8)undo()?mul(8,5))\n"
    ...> ]
    iex> AOC.Day03.b(input)
    {:ok, 48}
  """
  def b(input) do
    result =
      Stream.concat(Stream.map(input, &String.graphemes/1))
      |> Enum.reduce({[], nil}, fn x, {vals, state} ->
        case Parser.B.parse(state, x) do
          {:val, n} -> {vals ++ [n], nil}
          new_state -> {vals, new_state}
        end
      end)
      |> (fn {vals, _} -> vals end).()
      |> Enum.sum()

    {:ok, result}
  end
end
