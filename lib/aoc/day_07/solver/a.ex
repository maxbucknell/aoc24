defmodule AOC.Day07.Solver.A do
  @doc ~S"""
  As per 7A rules, is a line soluble?


  ## Examples

    iex> AOC.Day07.Solver.A.has_solution?({190, [19, 10]})
    true
    iex> AOC.Day07.Solver.A.has_solution?({292, [20, 16, 6, 11]})
    true
    iex> AOC.Day07.Solver.A.has_solution?({156, [6, 15]})
    false
  """
  def has_solution?({target, _}) when target < 0 do
    false
  end

  def has_solution?({_, []}), do: false

  def has_solution?({target, [next]}) do
    target == next
  end

  def has_solution?({target, [next | rest]}) do
    if rem(target, next) == 0 do
      # Try multiplying...
      if has_solution?({div(target, next), rest}) do
        true
      else
        has_solution?({target - next, rest})
      end
    else
      has_solution?({target - next, rest})
    end
  end
end
