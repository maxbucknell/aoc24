defmodule AOC.Day18.SpaceTest do
  use ExUnit.Case, async: true

  alias AOC.Day18.Space

  test "Basic route finding" do
    space = %Space{width: 7, height: 7}

    assert Space.navigate(space, {0, 0}, {6, 6}) == 12
  end

  test "With obstacles" do
    obstacles =
      MapSet.new([
        {5, 4},
        {4, 2},
        {4, 5},
        {3, 0},
        {2, 1},
        {6, 3},
        {2, 4},
        {1, 5},
        {0, 6},
        {3, 3},
        {2, 6},
        {5, 1}
      ])

    space = %Space{width: 7, height: 7, obstacles: obstacles}

    assert Space.navigate(space, {0, 0}, {6, 6}) == 22
  end
end
