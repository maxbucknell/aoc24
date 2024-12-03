defmodule AOC.Day03 do
  alias AOC.Day03.Parser

  @doc ~S"""
    iex> input = String.codepoints("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
    iex> AOC.Day03.a(input)
    {:ok, 161}
  """
  def a(input) do
    result =
      input
      |> Enum.reduce({[], nil}, fn x, {vals, state} ->
        case Parser.parse(state, x) do
          {:val, n} -> {vals ++ [n], nil}
          new_state -> {vals, new_state}
        end
      end)
      |> (fn {vals, _} -> vals end).()
      |> Enum.sum()

    {:ok, result}
  end
end
