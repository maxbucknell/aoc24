defmodule AOC.Day07.Solver.B do
  @doc ~S"""
  As per 7B rules, is a line soluble?


  ## Examples

    # iex> AOC.Day07.Solver.B.has_solution?({190, [19, 10]})
    # true
    # iex> AOC.Day07.Solver.B.has_solution?({292, [20, 16, 6, 11]})
    # true
    # iex> AOC.Day07.Solver.B.has_solution?({156, [6, 15]})
    # true
    # iex> AOC.Day07.Solver.B.has_solution?({7290, [15, 6, 8, 6]})
    # true
    # iex> AOC.Day07.Solver.B.has_solution?({161011, [13, 10, 16]})
    # false
    iex> AOC.Day07.Solver.B.has_solution?({2964061, [1, 6, 78, 95, 4]})
    true
  """
  def has_solution?({_, []}), do: false

  def has_solution?({target, [next]}) do
    if target == next do
      true
    else
      false
    end
  end

  def has_solution?({target, _}) when target < 0 do
    false
  end

  def has_solution?({target, parts}) do
    [:concatenate, :multiply, :add]
    |> Enum.reduce_while(false, fn operator, _ ->
      if run_one(operator, target, parts) do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end

  defp run_one(:concatenate, target, [first | tail]) do
    digits_count = count_digits(first)
    power = 10 ** digits_count

    if rem(target, power) == first do
      has_solution?({div(target, power), tail})
    else
      false
    end
  end

  defp run_one(:multiply, target, [first | tail]) do
    if rem(target, first) == 0 do
      has_solution?({div(target, first), tail})
    else
      false
    end
  end

  defp run_one(:add, target, [first | tail]) do
    has_solution?({target - first, tail})
  end

  defp run_one(_, _, _) do
    false
  end

  def count_digits(n) do
    log = :math.log10(n)

    Kernel.floor(log + 1)
  end
end
