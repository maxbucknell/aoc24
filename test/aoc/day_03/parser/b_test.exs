defmodule AOC.Day03.Parser.BTest do
  use ExUnit.Case, async: true

  alias AOC.Day03.Parser.B, as: Parser

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

  test "Don't() calls are parsed" do
    lhs =
      Parser.parse(nil, "d")
      |> Parser.parse("o")
      |> Parser.parse("n")
      |> Parser.parse("'")
      |> Parser.parse("t")
      |> Parser.parse("(")
      |> Parser.parse(")")

    assert lhs == :disable
  end

  test "Multiplicaiton can be disabled" do
    lhs =
      Parser.parse(nil, "d")
      |> Parser.parse("o")
      |> Parser.parse("n")
      |> Parser.parse("'")
      |> Parser.parse("t")
      |> Parser.parse("(")
      |> Parser.parse(")")
      |> Parser.parse("m")
      |> Parser.parse("u")
      |> Parser.parse("l")
      |> Parser.parse("(")
      |> Parser.parse("2")
      |> Parser.parse("3")
      |> Parser.parse(",")
      |> Parser.parse("1")
      |> Parser.parse("9")
      |> Parser.parse(")")

    assert lhs == :disable
  end

  test "Multiplications can be re-enabled" do
    lhs =
      Parser.parse(nil, "d")
      |> Parser.parse("o")
      |> Parser.parse("n")
      |> Parser.parse("'")
      |> Parser.parse("t")
      |> Parser.parse("(")
      |> Parser.parse(")")
      |> Parser.parse("d")
      |> Parser.parse("o")
      |> Parser.parse("(")
      |> Parser.parse(")")
      |> Parser.parse("m")
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
end
