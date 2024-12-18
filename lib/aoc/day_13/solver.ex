defmodule AOC.Day13.Solver do
  alias AOC.Utils.Matrix

  @doc ~S"""
  Find a solution for a single game.

  Returns either the number of presses required for each button, or
  {:error}.

  A game has a solution iff:

   - The matrix is invertible
   - The vector in the new coordinate space is positive
   -  ... and made of whole numbers
   -  ... that are less than 101

  We do the whole number check by rounding and reversing the
  calculation, to account for floating point weirdness.

  ## Examples

    iex> game = {{{94, 22}, {34, 67}}, {8400, 5400}}
    iex> solve(game)
    {:ok, 80, 40}
    iex> game = {{{26, 67}, {66, 21}}, {12748, 12176}}
    iex> solve(game)
    {:error}
    iex> game = {{{17, 84}, {86, 37}}, {7870, 6450}}
    iex> solve(game)
    {:ok, 38, 86}
    iex> game = {{{69, 27}, {23, 71}}, {18641, 10279}}
    iex> solve(game)
    {:error}
  """
  @spec solve(AOC.Day13.Parser.game()) :: {:ok, integer(), integer()} | {:error}
  def solve({m, v}) do
    with {:ok, inverse} <- Matrix.invert(m),
         {a, b} <- Matrix.vector_multiply(inverse, v),
         true <- 0 < a and a <= 100,
         true <- 0 < b and b <= 100,
         a <- round(a),
         b <- round(b),
         ^v <- Matrix.vector_multiply(m, {a, b}) do
      {:ok, a, b}
    else
      _ -> {:error}
    end
  end
end
