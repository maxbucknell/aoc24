defmodule AOC.Day06.RoomTest do
  use ExUnit.Case, async: true

  alias AOC.Day06.Room

  test "Finds obstacles" do
    room = %Room{
      width: 10,
      height: 10,
      rows: %{
        0 => [4],
        1 => [9, 2],
        3 => [2],
        4 => [7],
        6 => [1],
        7 => [8],
        8 => [0],
        9 => [6]
      },
      cols: %{
        0 => [8],
        1 => [6],
        2 => [3, 1],
        4 => [0],
        6 => [9],
        7 => [4],
        8 => [7],
        9 => [1]
      }
    }

    actual = Room.next_obstacle(room, {4, 6, :up})
    expected = {4, 0}

    assert actual == expected

    actual = Room.next_obstacle(room, {5, 6, :up})
    expected = nil

    assert actual == expected

    actual = Room.next_obstacle(room, {0, 1, :right})
    expected = {2, 1}

    assert actual == expected

    actual = Room.next_obstacle(room, {4, 1, :right})
    expected = {9, 1}

    assert actual == expected

    actual = Room.next_obstacle(room, {6, 6, :down})
    expected = {6, 9}

    assert actual == expected

    actual = Room.next_obstacle(room, {7, 8, :left})
    expected = {0, 8}

    assert actual == expected
  end

  test "Moving to obstacle" do
    room = %Room{
      width: 10,
      height: 10,
      rows: %{
        0 => [4],
        1 => [9, 2],
        3 => [2],
        4 => [7],
        6 => [1],
        7 => [8],
        8 => [0],
        9 => [6]
      },
      cols: %{
        0 => [8],
        1 => [6],
        2 => [3, 1],
        4 => [0],
        6 => [9],
        7 => [4],
        8 => [7],
        9 => [1]
      }
    }

    actual = Room.move_to_obstacle(room, {4, 0}, {4, 6, :up})

    expected = {
      {4, 1},
      MapSet.new([{4, 6}, {4, 5}, {4, 4}, {4, 3}, {4, 2}, {4, 1}])
    }

    assert actual == expected
  end

  test "Moving to edge" do
    room = %Room{
      width: 10,
      height: 10,
      rows: %{
        0 => [4],
        1 => [9, 2],
        3 => [2],
        4 => [7],
        6 => [1],
        7 => [8],
        8 => [0],
        9 => [6]
      },
      cols: %{
        0 => [8],
        1 => [6],
        2 => [3, 1],
        4 => [0],
        6 => [9],
        7 => [4],
        8 => [7],
        9 => [1]
      }
    }

    actual = Room.move_to_obstacle(room, nil, {5, 6, :up})

    expected = {
      {5, 0},
      MapSet.new([{5, 6}, {5, 5}, {5, 4}, {5, 3}, {5, 2}, {5, 1}, {5, 0}])
    }

    assert actual == expected
  end
end
