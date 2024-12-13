defmodule AOC.Day11 do
  @doc ~S"""
  Day 10, Part A

  ## Example

    iex> input = ["125 17\n"]
    iex> AOC.Day11.a(input)
    {:ok, 55312}
  """
  def a([input | _]) do
    stones =
      String.split(input)
      |> Enum.map(&String.to_integer/1)
      |> Enum.frequencies()

    result = AOC.Day11.Processor.run(stones, 25) |> Map.values() |> Enum.sum()

    {:ok, result}
  end

  def b([input | _]) do
    stones =
      String.split(input)
      |> Enum.map(&String.to_integer/1)
      |> Enum.frequencies()

    result = AOC.Day11.Processor.run(stones, 75) |> Map.values() |> Enum.sum()

    {:ok, result}
  end
end
