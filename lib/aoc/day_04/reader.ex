defmodule AOC.Day04.Reader do
  @doc ~S"""
  Read a single line of wordsearch and return new state.

  To solve the wordsearch line by line, we need to find steps of possible
  matches. That is to say:

   - Any x (start of xmas)
   - Any s (end of xmas)
   - Anything fed to us by the previous state, which is:
     - Any m at the same, 1 below, or 1 above the index of an x found on
       the previous line.
     - Any a at the same, 1 below, or 1 above the index of an s found on
       the previous line.
     - Any a found in the line of a previous xm
     - Any m found in the line of a previous sa

  Then, when we find either:

   - An s in the lne of a previous xma
   - An x in the line of a previous sam

  We increment state.count.

  We also need to track xmas and samx that are found only on this line.
  This can still work in the character-wise fashion, but we need to track
  the current line's state in the reducer.

  """
  def read_line(line, state \\ %{}) do
    acc = %{
      current: state,
      next: %{count: Map.get(state, :count, 0)}
    }

    String.graphemes(line)
    |> Enum.with_index()
    |> Enum.reduce(acc, fn {c, i}, acc ->
      matches = Map.get(acc.current, i, []) |> Enum.filter(fn {cc, _, _} -> cc == c end)

      case c do
        "X" ->
          acc
          |> update_states(:new, i, "M", "X")
          # All matches are complete words at this point
          |> update_count(Enum.count(matches))

        "M" ->
          Enum.reduce(matches, acc, fn {_, direction, initial}, acc ->
            case initial do
              "X" -> update_states(acc, direction, i, "A", "X")
              "S" -> update_states(acc, direction, i, "X", "S")
            end
          end)

        "A" ->
          Enum.reduce(matches, acc, fn {_, direction, initial}, acc ->
            case initial do
              "X" -> update_states(acc, direction, i, "S", "X")
              "S" -> update_states(acc, direction, i, "M", "S")
            end
          end)

        "S" ->
          acc
          |> update_states(:new, i, "A", "S")
          # All matches are complete words at this point
          |> update_count(Enum.count(matches))

        _ ->
          acc
      end
    end)
    |> Map.fetch!(:next)
  end

  defp update_states(%{current: current, next: next}, :new, i, c, initial) do
    %{current: current, next: next}
    |> update_states(:across, i, c, initial)
    |> update_states(:left, i, c, initial)
    |> update_states(:down, i, c, initial)
    |> update_states(:right, i, c, initial)
  end

  defp update_states(%{current: current, next: next}, :across, i, c, initial) do
    value = {c, :across, initial}
    current = Map.update(current, i + 1, [value], &[value | &1])

    %{current: current, next: next}
  end

  defp update_states(%{current: current, next: next}, :left, i, c, initial) do
    value = {c, :left, initial}
    next = Map.update(next, i - 1, [value], &[value | &1])

    %{current: current, next: next}
  end

  defp update_states(%{current: current, next: next}, :down, i, c, initial) do
    value = {c, :down, initial}
    next = Map.update(next, i, [value], &[value | &1])

    %{current: current, next: next}
  end

  defp update_states(%{current: current, next: next}, :right, i, c, initial) do
    value = {c, :right, initial}
    next = Map.update(next, i + 1, [value], &[value | &1])

    %{current: current, next: next}
  end

  defp update_count(%{current: current, next: next}, increment) do
    next = Map.update(next, :count, increment, &(&1 + increment))

    %{current: current, next: next}
  end
end
