defmodule AOC.Day14 do
  @doc ~S"""
  Day 14, Part A

  ## Example

    iex> input = [
    ...>   "p=0,4 v=3,-3\n",
    ...>   "p=6,3 v=-1,-3\n",
    ...>   "p=10,3 v=-1,2\n",
    ...>   "p=2,0 v=2,-1\n",
    ...>   "p=0,0 v=1,3\n",
    ...>   "p=3,0 v=-2,-2\n",
    ...>   "p=7,6 v=-1,-3\n",
    ...>   "p=3,0 v=-1,-2\n",
    ...>   "p=9,3 v=2,3\n",
    ...>   "p=7,3 v=-1,2\n",
    ...>   "p=2,4 v=2,-3\n",
    ...>   "p=9,5 v=-3,-3\n",
    ...> ]
    iex> a(input, 11, 7)
    {:ok, 12}
  """
  @spec(a(Enumerable.t(String.t())) :: {:ok, integer()}, {:error, atom()})
  def a(input, width \\ 101, height \\ 103) do
    mid_x = div(width - 1, 2)
    mid_y = div(height - 1, 2)

    result =
      AOC.Day14.Parser.parse(input)
      |> Stream.map(fn {{x, y}, {dx, dy}} ->
        # Add width and height so we don't have to worry about
        # negative remainders
        x = x + 100 * (dx + width)
        y = y + 100 * (dy + height)

        {rem(x, width), rem(y, height)}
      end)
      |> Enum.frequencies_by(fn {x, y} ->
        cond do
          x < mid_x and y < mid_y -> :top_left
          x > mid_x and y < mid_y -> :top_right
          x > mid_x and y > mid_y -> :bottom_right
          x < mid_x and y > mid_y -> :bottom_left
          true -> :centre
        end
      end)
      |> Map.delete(:centre)
      |> Map.values()
      |> Enum.product()

    {:ok, result}
  end
end
