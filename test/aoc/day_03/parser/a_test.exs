defmodule AOC.Day03.Parser.ATest do
  use ExUnit.Case, async: true

  alias AOC.Day03.Parser.A, as: Parser

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

  test "Should find a complete multiplication" do
    lhs =
      Parser.parse(nil, "m")
      |> Parser.parse("u")
      |> Parser.parse("l")
      |> Parser.parse("(")
      |> Parser.parse("2")
      |> Parser.parse("3")
      |> Parser.parse(",")
      |> Parser.parse("1")
      |> Parser.parse("9")
      |> Parser.parse(")")

    assert lhs == {:val, 437}
  end

  test "Something invalid makes nil" do
    lhs =
      Parser.parse(nil, "m")
      |> Parser.parse("u")
      |> Parser.parse("l")
      |> Parser.parse("(")
      |> Parser.parse("2")
      |> Parser.parse("3")
      |> Parser.parse(",")
      |> Parser.parse(",")
      |> Parser.parse("1")
      |> Parser.parse("9")
      |> Parser.parse(")")

    assert lhs == nil
  end
end
