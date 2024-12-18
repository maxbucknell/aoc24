defmodule AOC.Utils.Matrix do
  @moduledoc ~S"""
  Some really basic linear algebra functions.

  Day 13 of the Advent of Code is asking a lot of questions about
  changing the basis of a vector. So here I am, revisiting things I
  learned about in university.

  All functions here operate on 2x2 matrices. I'm not smart enough
  for three spatial dimensions.

  If a later question needs something in 3d, watch me get real clever
  real fast.
  """
  @type value() :: float() | integer()
  @type vector() :: {value(), value()}
  @type matrix() :: {vector(), vector()}

  @doc ~S"""
  Identity matrix!

    iex> identity()
    {{1, 0}, {0, 1}}
  """
  @spec identity() :: matrix()
  def identity() do
    {
      {1, 0},
      {0, 1}
    }
  end

  @doc ~S"""
  Compute determinant of matrix.

  In two dimensions, this is ad - bc.

  ## Examples

    iex> determinant(identity())
    1
    iex> determinant({{1, 4}, {9, 3}})
    -33
  """
  @spec determinant(matrix()) :: value()
  def determinant({{a, b}, {c, d}}) do
    a * d - b * c
  end

  @doc ~S"""
  Compute the sum of two matrices.
  """
  @spec add(matrix(), matrix()) :: matrix()
  def add({{a, b}, {c, d}}, {{p, q}, {r, s}}) do
    {{a + p, b + q}, {c + r, d + s}}
  end

  @spec scalar_multiply(value(), matrix()) :: matrix()
  def scalar_multiply(n, {{a, b}, {c, d}}) do
    {{n * a, n * b}, {n * c, n * d}}
  end

  @spec subtract(matrix(), matrix()) :: matrix()
  def subtract(left, right) do
    scalar_multiply(-1, right) |> add(left)
  end

  @spec vector_multiply(matrix(), vector()) :: vector()
  def vector_multiply({{a, b}, {c, d}}, {x, y}) do
    {a * x + b * y, c * x + d * y}
  end

  @doc ~S"""
  If possible, find the inverse of a matrix.

  Since this is only two dimensional, we can very easily use Gaussian
  substitution to compute the values algebraically. No need for
  anything too fancy.

  Essentially, we perform row-wise operations on the given matrix and
  the identity matrix. Once we have turned our given matrix into the
  identity, then our identity matrix will become our inverse.

  ## Examples

    iex> invert({{1, 0}, {0, 1}})
    {:ok, {{1.0, -0.0}, {-0.0, 1.0}}}
    iex> invert({{-1, 1.5}, {1, -1}})
    {:ok, {{2.0, 3.0}, {2.0, 2.0}}}
  """
  @spec invert(matrix()) :: {:ok, matrix()} | {:error, :matrix_not_invertible}
  def invert({{a, b}, {c, d}}) when a * d - b * c != 0 do
    {r, s} = {-(c / a), 1}
    d = d - b * (c / a)

    {p, q} = {1 - r * (b / d), -(s * (b / d))}

    {:ok, {{p / a, q / a}, {r / d, s / d}}}
  end

  def invert(_) do
    {:error, :matrix_not_invertible}
  end
end
