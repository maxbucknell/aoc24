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
end
