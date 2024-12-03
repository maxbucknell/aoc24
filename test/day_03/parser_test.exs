defmodule AOC.Day03.ParserTest do
  use ExUnit.Case, async: true

  alias AOC.Day03.Parser

  test "Should wait for m" do
    assert Parser.parse(nil, "m") == {:m}
  end

  test "Invalid input should return nil" do
    assert Parser.parse(nil, "x") == nil
    assert Parser.parse({:m}, "x") == nil
  end

  test "Should find mul" do
    lhs =
      Parser.parse(nil, "m")
      |> Parser.parse("u")
      |> Parser.parse("l")

    assert lhs == {:mul}
  end
end
