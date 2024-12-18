defmodule AOC.Day13.Parser do
  @type game() :: {AOC.Utils.Matrix.matrix(), AOC.Utils.Matrix.vector()}

  @button ~r/X\+(?<x>\d+), Y\+(?<y>\d+)/
  @prize ~r/X=(?<x>\d+), Y=(?<y>\d+)/

  @doc ~S"""
  Parse input for Day 13

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
    iex> parse(input)
    [
      {
        {{69, 27}, {23, 71}},
        {18641, 10279}
      },
      {
        {{17, 84}, {86, 37}},
        {7870, 6450}
      },
      {
        {{26, 67}, {66, 21}},
        {12748, 12176}
      },
      {
        {{94, 22}, {34, 67}},
        {8400, 5400}
      }
    ]

  """
  @spec parse(Enumerable.t(String.t())) :: list(game())
  def parse(input) do
    Enum.reduce(input, [], &parse_line/2)
  end

  @spec parse_line(String.t(), list(game())) :: list(game())
  def parse_line("Button A: " <> line, games) do
    %{"x" => x, "y" => y} = Regex.named_captures(@button, line)

    x = String.to_integer(x)
    y = String.to_integer(y)

    [{{{x, 0}, {y, 0}}, {0, 0}} | games]
  end

  def parse_line("Button B: " <> line, [{{{a, _}, {c, _}}, _} | games]) do
    %{"x" => x, "y" => y} = Regex.named_captures(@button, line)

    x = String.to_integer(x)
    y = String.to_integer(y)

    [{{{a, x}, {c, y}}, {0, 0}} | games]
  end

  def parse_line("Prize: " <> line, [{m, _} | games]) do
    %{"x" => x, "y" => y} = Regex.named_captures(@prize, line)

    x = String.to_integer(x)
    y = String.to_integer(y)

    [{m, {x, y}} | games]
  end

  def parse_line(_, games) do
    games
  end
end
