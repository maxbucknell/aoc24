defmodule AOC.Day18 do
  alias AOC.Day18.Space

  @doc ~S"""
  Day 18, Part A

  ## Example

    iex> input = [
    ...>   "5,4\n",
    ...>   "4,2\n",
    ...>   "4,5\n",
    ...>   "3,0\n",
    ...>   "2,1\n",
    ...>   "6,3\n",
    ...>   "2,4\n",
    ...>   "1,5\n",
    ...>   "0,6\n",
    ...>   "3,3\n",
    ...>   "2,6\n",
    ...>   "5,1\n",
    ...>   "1,2\n",
    ...>   "5,5\n",
    ...>   "2,5\n",
    ...>   "6,5\n",
    ...>   "1,4\n",
    ...>   "0,4\n",
    ...>   "6,4\n",
    ...>   "1,1\n",
    ...>   "6,1\n",
    ...>   "1,0\n",
    ...>   "0,5\n",
    ...>   "1,6\n",
    ...>   "2,0\n",
    ...> ]
    iex> a(input, size: 7, take_first: 12)
    {:ok, 22}
  """
  def a(input, opts \\ []) do
    size = Keyword.get(opts, :size, 71)
    count = Keyword.get(opts, :take_first, 1024)

    obstacles =
      Stream.take(input, count)
      |> Stream.map(fn line ->
        [x, y] =
          String.trim(line)
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)

        {x, y}
      end)
      |> MapSet.new()

    space = %Space{width: size, height: size, obstacles: obstacles}

    result = Space.navigate(space, {0, 0}, {70, 70})

    {:ok, result}
  end
end
