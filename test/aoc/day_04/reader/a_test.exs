defmodule AOC.Day04.Reader.ATest do
  use ExUnit.Case, async: true

  alias AOC.Day04.Reader.A, as: Reader

  test "Finds an x" do
    actual = Reader.read_line("X")

    expected = %{
      :count => 0,
      -1 => [{"M", :left, "X"}],
      0 => [{"M", :down, "X"}],
      1 => [{"M", :right, "X"}]
    }

    assert actual == expected

    actual = Reader.read_line("ABXCXEF")

    expected = %{
      :count => 0,
      1 => [{"M", :left, "X"}],
      2 => [{"M", :down, "X"}],
      3 => [{"M", :left, "X"}, {"M", :right, "X"}],
      4 => [{"M", :down, "X"}],
      5 => [{"M", :right, "X"}]
    }

    assert actual == expected
  end

  test "Finds horizontal xmas" do
    actual = Reader.read_line("XMAS")

    expected = %{
      :count => 1,
      -1 => [{"M", :left, "X"}],
      0 => [{"M", :down, "X"}],
      1 => [{"M", :right, "X"}],
      2 => [{"A", :left, "S"}],
      3 => [{"A", :down, "S"}],
      4 => [{"A", :right, "S"}]
    }

    assert actual == expected
  end

  test "Parses a line" do
    line = "MMMSXXMASM"

    actual = Reader.read_line(line)

    expected = %{
      :count => 1,
      2 => [{"A", :left, "S"}],
      3 => [{"M", :left, "X"}, {"A", :down, "S"}],
      4 => [{"M", :left, "X"}, {"M", :down, "X"}, {"A", :right, "S"}],
      5 => [{"M", :down, "X"}, {"M", :right, "X"}],
      6 => [{"M", :right, "X"}],
      7 => [{"A", :left, "S"}],
      8 => [{"A", :down, "S"}],
      9 => [{"A", :right, "S"}]
    }

    assert actual == expected
  end

  test "Parses a line with initial state" do
    state = %{
      :count => 12,
      1 => [{"S", :right, "X"}, {"M", :down, "S"}],
      3 => [{"S", :right, "X"}, {"X", :down, "S"}],
      4 => [{"A", :down, "S"}]
    }

    line = "XSMXA"

    actual = Reader.read_line(line, state)

    expected = %{
      :count => 14,
      -1 => [{"M", :left, "X"}],
      0 => [{"A", :left, "S"}, {"M", :down, "X"}],
      1 => [{"A", :down, "S"}, {"M", :right, "X"}],
      2 => [{"M", :left, "X"}, {"A", :right, "S"}],
      3 => [{"M", :down, "X"}],
      4 => [{"M", :down, "S"}, {"M", :right, "X"}]
    }

    assert actual == expected
  end
end
