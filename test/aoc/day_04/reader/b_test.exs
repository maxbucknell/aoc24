defmodule AOC.Day04.Reader.BTest do
  use ExUnit.Case, async: false

  alias AOC.Day04.Reader.B, as: Reader

  test "Finds first line" do
    actual = Reader.read_line("MXM")

    expected = %{
      :count => 0,
      1 => [{"A", "M", "M"}]
    }

    assert actual == expected

    actual = Reader.read_line("MXS")

    expected = %{
      :count => 0,
      1 => [{"A", "M", "S"}]
    }

    assert actual == expected
  end

  test "Finds an A" do
    state = Reader.read_line("MXS")

    actual = Reader.read_line("XAX", state)

    expected = %{
      :count => 0,
      0 => [{"M", "M", "S"}]
    }

    assert actual == expected
  end

  test "Finds a whole X-MAS" do
    state = Reader.read_line("SMM")
    state = Reader.read_line("MAM", state)

    actual = Reader.read_line("SSM", state)

    expected = %{
      :count => 1,
      1 => [{"A", "S", "M"}]
    }

    assert actual == expected
  end
end
