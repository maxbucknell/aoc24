defmodule AOC.Day05.FixerTest do
  use ExUnit.Case, async: true

  alias AOC.Day05.Fixer

  test "Empty input" do
    assert Fixer.generate_valid_update(%{}) == {:ok, []}
  end

  test "Single value" do
    dependencies = %{
      1 => MapSet.new()
    }

    actual = Fixer.generate_valid_update(dependencies)
    expected = {:ok, [1]}

    assert actual == expected
  end

  test "Example input" do
    dependencies = %{
      13 => MapSet.new([61, 29]),
      29 => MapSet.new([61]),
      61 => MapSet.new()
    }

    actual = Fixer.generate_valid_update(dependencies)
    expected = {:ok, [61, 29, 13]}

    assert actual == expected
  end
end
