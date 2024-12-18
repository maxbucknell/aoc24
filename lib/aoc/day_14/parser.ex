defmodule AOC.Day14.Parser do
  alias AOC.Utils.Matrix

  @pattern ~r/p=(?<x>\d+),(?<y>\d+) v=(?<dx>-?\d+),(?<dy>-?\d+)/

  @type robot() :: {Matrix.vector(), Matrix.vector()}

  @doc ~S"""
  Parse Day 14 input.

  ## Example

    iex> input = [
    ...>   "p=0,4 v=3,-3\n",
    ...>   "p=6,3 v=-1,-3\n",
    ...>   "p=10,3 v=-1,2\n",
    ...>   "p=2,0 v=2,-1\n",
    ...>   "p=0,0 v=1,3\n",
    ...> ]
    iex> parse(input) |> Enum.to_list()
    [
      {{0, 4}, {3, -3}},
      {{6, 3}, {-1, -3}},
      {{10, 3}, {-1, 2}},
      {{2, 0}, {2, -1}},
      {{0, 0}, {1, 3}}
    ]
  """
  @spec parse(Enumerable.t(String.t())) :: Enumerable.t(robot())
  def parse(input) do
    Stream.map(input, &parse_line/1)
  end

  @spec parse_line(String.t()) :: robot()
  def parse_line(line) do
    case Regex.named_captures(@pattern, line) do
      %{"x" => x, "y" => y, "dx" => dx, "dy" => dy} ->
        {
          {
            String.to_integer(x),
            String.to_integer(y)
          },
          {
            String.to_integer(dx),
            String.to_integer(dy)
          }
        }
    end
  end
end
