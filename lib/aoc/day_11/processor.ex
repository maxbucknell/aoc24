defmodule AOC.Day11.Processor do
  def run(initial, times) do
    {result, _} =
      Enum.reduce(1..times, {initial, %{}}, fn _, {stones, memo} ->
        tick(stones, memo)
      end)

    result
  end

  def tick(stones, memo) do
    {new_stones, memo} =
      Map.to_list(stones)
      |> Enum.map_reduce(memo, fn {stone, count}, memo ->
        {result, memo} =
          case Map.get(memo, stone) do
            nil ->
              result = process(stone)
              memo = Map.put(memo, stone, result)
              {result, memo}

            result ->
              {result, memo}
          end

        new_stones =
          result
          |> Enum.reduce(%{}, fn new_stone, new_stones ->
            Map.update(new_stones, new_stone, count, &(&1 + count))
          end)

        {new_stones, memo}
      end)

    new_stones = Enum.reduce(new_stones, %{}, &Map.merge(&1, &2, fn _k, a, b -> a + b end))

    {new_stones, memo}
  end

  def process(0) do
    [1]
  end

  def process(stone) do
    digits = Integer.digits(stone)
    size = Enum.count(digits)

    case rem(size, 2) do
      0 ->
        {a, b} = Enum.split(digits, div(size, 2))
        Enum.map([a, b], &Integer.undigits/1)

      1 ->
        [stone * 2024]
    end
  end
end
