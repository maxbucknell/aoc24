defmodule AOC.Day09 do
  @moduledoc ~S"""
  Day 9

  I'm doing a new thing here where I write my thoughts and feelings
  about the question down in the module doc.

  My first instinct here was to reach for a memory buffer, something
  double-ended that allows me to take from both sides. But that isn't
  really something that Elixir thrives with.

  The disk has a number of used blocks, that can be counted via a
  single scan of the data structure. That gives us the number of blocks
  that will be filled. Anything with index less than x will be full,
  and anything greater than that will be empty.

  Then, we need to calculate the checksum. To do that:

   - If the value is full, we return the checksum.
   - If the value is empty, we take the last full block.

  Part B is a little more tricky. I can re-use a lot of my logic, but
  I think it is going to be easiest if my scan tracks used blocks by
  their size, and position.

  All sizes are guaranteed to be in 1..9, since they are single digits.

  This means that I can use only a small map, storing their IDs. In
  fact, Enum.group_by gives me exactly what I want here.

  We need to wrap each file with its starting position. Then we need to
  group them, ordering the :empty from the left, the others from the right.

  From there it should be straightforward to recurse through :empty and
  put blocks in there, and then reassemble the disk.
  """

  @doc ~S"""
  Day 9, Part A.

  ## Example

    iex> input = ["2333133121414131402\n"]
    iex> AOC.Day09.a(input)
    {:ok, 1928}
  """
  def a(input) do
    result =
      AOC.Day09.Parser.parse(input)
      |> AOC.Day09.DiskUtils.compact_disk()
      |> AOC.Day09.DiskUtils.checksum()

    {:ok, result}
  end

  @doc ~S"""
  Day 9, Part A.

  ## Example

    iex> input = ["2333133121414131402\n"]
    iex> AOC.Day09.b(input)
    {:ok, 2858}
  """
  def b(input) do
    result =
      AOC.Day09.Parser.parse(input)
      |> AOC.Day09.DiskUtils.defragmented_compact()
      |> AOC.Day09.DiskUtils.checksum_from_positions()

    {:ok, result}
  end
end
