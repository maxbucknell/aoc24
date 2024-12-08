defmodule AOC.Day08.Parser do
  @doc ~S"""
  Parse puzzle input.

  ## Example

    iex> input = [
    ...>   "............\n",
    ...>   "........0...\n",
    ...>   ".....0......\n",
    ...>   ".......0....\n",
    ...>   "....0.......\n",
    ...>   "......A.....\n",
    ...>   "............\n",
    ...>   "............\n",
    ...>   "........A...\n",
    ...>   ".........A..\n",
    ...>   "............\n",
    ...> ]
    iex> AOC.Day08.Parser.parse(input)
    %{
      width: 12,
      height: 11,
      locations: %{
        "0" => [{4, 4}, {7, 3}, {5, 2}, {8, 1}],
        "A" => [{9, 9}, {8, 8}, {6, 5}]
      }
    }
  """
  def parse(input) do
    Stream.with_index(input)
    |> Enum.reduce(%{}, fn {line, y}, result ->
      {width, transmitters} = parse_line(line)

      locations = Map.get(result, :locations, %{})

      locations =
        Enum.reduce(transmitters, locations, fn {x, c}, locations ->
          Map.update(locations, c, [{x, y}], &[{x, y} | &1])
        end)

      Map.put(result, :locations, locations)
      |> Map.put(:width, width)
      |> Map.put(:height, y + 1)
    end)
  end

  @doc ~S"""
  Parse a line of puzzle input.

  ## Examples

    iex> AOC.Day08.Parser.parse_line("............\n")
    {12, []}
    iex> AOC.Day08.Parser.parse_line(".......0....\n")
    {12, [{7, "0"}]}
    iex> AOC.Day08.Parser.parse_line("......A.....\n")
    {12, [{6, "A"}]}
    iex> AOC.Day08.Parser.parse_line("...a..A.....\n")
    {12, [{6, "A"}, {3, "a"}]}
  """
  def parse_line(line) do
    String.trim(line)
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce({0, []}, fn {c, i}, {_, acc} ->
      case c do
        "." -> {i + 1, acc}
        c -> {i + 1, [{i, c} | acc]}
      end
    end)
  end
end
