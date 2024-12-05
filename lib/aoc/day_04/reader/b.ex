defmodule AOC.Day04.Reader.B do
  @doc ~S"""
  This is going to be very similar to part A.

  Where it differs is in what we look for, and what the initial settings
  are going to be. We also may not have to track directions.

   - S needs to look for:
      - S or M two spaces down, intial: S. It does this regardless of
        matches
      - For any matches:
         - If initial is M, we look for A at i-1, initial SM
         - If initial is S, we look for A at i-1, initial SS
         - If initial is of length 2, we came from an A, and initial is
           either MS or MM. Based on that, we look for an M or S respectively,
           with initial of MSS, or MMS.
         - If initial is of length 3, we have X-MAS and should increment
           the count!
   - M is similar to S
   - A does not start anything, but each match should:
      - Look for the opposite of the second initial at i-1 with the same
        initial
  """
  def read_line(line, state \\ %{}) do
    acc = %{
      current: state,
      next: %{count: Map.get(state, :count, 0)}
    }

    String.graphemes(line)
    |> Enum.with_index()
    |> Enum.reduce(acc, fn {c, i}, acc ->
      Map.get(acc.current, i, [])
      |> Enum.filter(fn match -> elem(match, 0) == c end)
      |> Enum.reduce(acc, &reduce_match(i, &1, &2))
      |> add_new_match(c, i)
    end)
    |> Map.fetch!(:next)
  end

  def reduce_match(i, {target, first}, %{current: current, next: next}) do
    value = {"A", first, target}

    next = Map.update(next, i - 1, [value], &[value | &1])

    %{current: current, next: next}
  end

  def reduce_match(i, {"A", first, second}, %{current: current, next: next}) do
    value = {other(second), first, second}

    next = Map.update(next, i - 1, [value], &[value | &1])

    %{current: current, next: next}
  end

  def reduce_match(i, {target, first, second}, %{current: current, next: next}) do
    value = {other(first), first, second, target}

    current = Map.update(current, i + 2, [value], &[value | &1])

    %{current: current, next: next}
  end

  def reduce_match(_i, {_target, _first, _, _}, %{current: current, next: next}) do
    next = Map.update(next, :count, 1, &(&1 + 1))

    %{current: current, next: next}
  end

  def add_new_match(%{current: current, next: next}, c, i) when c == "S" or c == "M" do
    s = {"S", c}
    m = {"M", c}

    current = Map.update(current, i + 2, [s, m], &[s, m | &1])

    %{current: current, next: next}
  end

  def add_new_match(acc, _c, _i), do: acc

  defp other("S"), do: "M"
  defp other("M"), do: "S"
end
