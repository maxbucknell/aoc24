defmodule AOC.Day02.Reactor.Reading do
  @enforce_keys [:dampener]
  defstruct [:dampener, levels: []]

  def new(dampener \\ 0, levels \\ []) do
    size = dampener + 2

    %__MODULE__{
      dampener: dampener,
      # We only need size most recent readings
      levels: Enum.slice(levels, -size, size)
    }
  end

  @doc ~S"""
  Register a new reading and return all possible safe actual values.
  """
  def register(reading, level) do
    new_levels = reading.levels ++ [level]

    cond do
      is_safe?(new_levels) ->
        [new(reading.dampener, new_levels)]

      reading.dampener < 1 ->
        []

      # We have a dampener to apply, so let's try
      true ->
        levels_count = Enum.count(new_levels)

        0..(levels_count - 1)
        |> Stream.map(fn i ->
          head = Enum.slice(new_levels, 0, i)
          [_ | tail] = Enum.slice(new_levels, i, levels_count)

          head ++ tail
        end)
        |> Stream.filter(fn dampened -> is_safe?(dampened) end)
        |> Enum.map(fn levels -> new(reading.dampener - 1, levels) end)
    end
  end

  @doc ~S"""
  Is a single list of level readings safe?

  ## Examples

    iex> AOC.Day02.Reactor.is_safe?([1, 2, 3, 4, 5])
    true
    iex> AOC.Day02.Reactor.is_safe?([1, 2, 4, 4, 5])
    false
    iex> AOC.Day02.Reactor.is_safe?([4, 2, 3, 4, 5])
    false
  """
  def is_safe?(levels) do
    Enum.reduce_while(levels, {:ok, nil, nil}, fn level, {:ok, prev_delta, prev_level} ->
      case {prev_delta, prev_level} do
        # We are the first item, assume true, no delta to set direction yet.
        {nil, nil} ->
          {:cont, {:ok, nil, level}}

        # level == previous_level, unsafe
        {_, ^level} ->
          {:halt, {:error}}

        # We are second, no delta, only testing magnitude
        {nil, ^prev_level} ->
          delta = level - prev_level

          if abs(delta) <= 3 do
            # Safe, and we can set delta
            {:cont, {:ok, delta, level}}
          else
            {:halt, {:error}}
          end

        {^prev_delta, ^prev_level} when prev_delta < 0 ->
          delta = level - prev_level

          if -3 <= delta and delta < 0 do
            {:cont, {:ok, delta, level}}
          else
            {:halt, {:error}}
          end

        {^prev_delta, ^prev_level} ->
          delta = level - prev_level

          if 0 < delta and delta <= 3 do
            {:cont, {:ok, delta, level}}
          else
            {:halt, {:error}}
          end
      end
    end)
    |> case do
      {:ok, _, _} -> true
      {:error} -> false
    end
  end
end
