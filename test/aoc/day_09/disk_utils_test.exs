defmodule AOC.Day09.DiskUtilsTest do
  use ExUnit.Case, async: true

  doctest AOC.Day09.DiskUtils

  test "Counts used blocks" do
    disk = [
      {0, 2},
      {:empty, 3},
      {1, 3},
      {:empty, 3},
      {2, 1},
      {:empty, 3},
      {3, 3},
      {:empty, 1},
      {4, 2},
      {:empty, 1},
      {5, 4},
      {:empty, 1},
      {6, 4},
      {:empty, 1},
      {7, 3},
      {:empty, 1},
      {8, 4},
      {9, 2}
    ]

    assert AOC.Day09.DiskUtils.count_blocks(disk) == {28, 14}
  end

  test "Splitting disks" do
    disk = [
      {0, 2},
      {:empty, 3},
      {1, 3},
      {:empty, 3},
      {2, 1},
      {:empty, 3},
      {3, 3},
      {:empty, 1},
      {4, 2},
      {:empty, 1},
      {5, 4},
      {:empty, 1},
      {6, 4},
      {:empty, 1},
      {7, 3},
      {:empty, 1},
      {8, 4},
      {9, 2}
    ]

    actual = AOC.Day09.DiskUtils.split_at(disk, 8)

    expected = {
      [{0, 2}, {:empty, 3}, {1, 3}],
      [{9, 2}, {8, 4}, {7, 3}, {6, 4}, {5, 4}, {4, 2}, {3, 3}, {2, 1}]
    }

    assert actual == expected

    actual = AOC.Day09.DiskUtils.split_at(disk, 28)

    expected = {
      [
        {0, 2},
        {:empty, 3},
        {1, 3},
        {:empty, 3},
        {2, 1},
        {:empty, 3},
        {3, 3},
        {:empty, 1},
        {4, 2},
        {:empty, 1},
        {5, 4},
        {:empty, 1},
        {6, 1}
      ],
      [{9, 2}, {8, 4}, {7, 3}, {6, 3}]
    }

    assert actual == expected
  end

  # test "Grouping by lengths" do
  #   disk = [
  #     {0, 2},
  #     {:empty, 3},
  #     {1, 3},
  #     {:empty, 3},
  #     {2, 1},
  #     {:empty, 3},
  #     {3, 3},
  #     {:empty, 1},
  #     {4, 2},
  #     {:empty, 1},
  #     {5, 4},
  #     {:empty, 1},
  #     {6, 4},
  #     {:empty, 1},
  #     {7, 3},
  #     {:empty, 1},
  #     {8, 4},
  #     {9, 2}
  #   ]

  #   actual = AOC.Day09.DiskUtils.by_lengths(disk)

  #   expected = %{
  #     :empty => [{3, 2}, {3, 8}, {3, 12}, {1, 18}, {1, 21}, {1, 26}, {1, 31}, {1, 35}],
  #     1 => [{2, 11}],
  #     2 => [{9, 40}, {4, 19}, {0, 0}],
  #     3 => [{7, 32}, {3, 15}, {1, 5}],
  #     4 => [{8, 36}, {6, 27}, {5, 22}]
  #   }

  #   assert actual == expected
  # end
end
