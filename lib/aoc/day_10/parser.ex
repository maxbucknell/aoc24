defmodule AOC.Day10.Parser do
  @doc ~S"""
  Parse input for Day 10.

  I'm going with a coordinate map, since this language doesn't jhave
  contiguous arrays. I'm also spitting out the locations of all the
  zeros to get us started.

  #Examples

    iex> input = [
    ...>   "0123\n",
    ...>   "1234\n"
    ...> ]
    iex> AOC.Day10.Parser.parse(input)
    {
      [{0,0}],
      %{
        {0,0} => 0,
        {1,0} => 1,
        {2,0} => 2,
        {3,0} => 3,
        {0,1} => 1,
        {1,1} => 2,
        {2,1} => 3,
        {3,1} => 4
      }
    }
  """
  def parse(input) do
    Stream.with_index(input)
    |> Enum.reduce({[], %{}}, &parse_line/2)
  end

  defp parse_line({line, y}, acc) do
    String.trim(line)
    |> String.graphemes()
    |> Stream.with_index()
    |> Enum.reduce(acc, &reduce_char(y, &1, &2))
  end

  defp reduce_char(y, {"0", x}, {zeros, map}) do
    point = {x, y}
    zeros = [point | zeros]
    map = Map.put(map, point, 0)

    {zeros, map}
  end

  defp reduce_char(y, {c, x}, {zeros, map}) do
    point = {x, y}
    map = Map.put(map, point, String.to_integer(c))

    {zeros, map}
  end
end
