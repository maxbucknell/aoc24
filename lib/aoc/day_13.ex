defmodule AOC.Day13 do
  @doc ~S"""
  Day 13, Part A

  ## Example

    iex> input = [
    ...>   "Button A: X+94, Y+34\n",
    ...>   "Button B: X+22, Y+67\n",
    ...>   "Prize: X=8400, Y=5400\n",
    ...>   "\n",
    ...>   "Button A: X+26, Y+66\n",
    ...>   "Button B: X+67, Y+21\n",
    ...>   "Prize: X=12748, Y=12176\n",
    ...>   "\n",
    ...>   "Button A: X+17, Y+86\n",
    ...>   "Button B: X+84, Y+37\n",
    ...>   "Prize: X=7870, Y=6450\n",
    ...>   "\n",
    ...>   "Button A: X+69, Y+23\n",
    ...>   "Button B: X+27, Y+71\n",
    ...>   "Prize: X=18641, Y=10279"
    ...> ]
    iex> a(input)
    {:ok, 480}
  """
  def a(input) do
    result =
      AOC.Day13.Parser.parse(input)
      |> Enum.flat_map(fn game ->
        case AOC.Day13.Solver.solve(game) do
          {:ok, a, b} -> [3 * a + b]
          {:error} -> []
        end
      end)
      |> Enum.sum()

    {:ok, result}
  end
end
