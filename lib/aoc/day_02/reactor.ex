defmodule AOC.Day02.Reactor do
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

  def register(reactor, level) do
    new_levels = reactor.levels ++ [level]

    cond do
      is_safe?(new_levels) ->
        {:ok, new(reactor.dampener, new_levels)}

      reactor.dampener < 1 ->
        {:error, :unsafe_level}

      # We have a dampener to apply, so let's try
      true ->
        levels_count = Enum.count(new_levels)

        # Try removing each reading until we get a safe one
        0..(levels_count - 1)
        |> Stream.map(fn i ->
          head = Enum.slice(new_levels, 0, i)
          [_ | tail] = Enum.slice(new_levels, i, levels_count)

          head ++ tail
        end)
        |> Enum.find(fn dampened -> is_safe?(dampened) end)
        |> case do
          nil ->
            {:error, :unsafe_level}

          levels ->
            {:ok, new(reactor.dampener - 1, levels)}
        end
    end
  end

  @doc ~S"""
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
