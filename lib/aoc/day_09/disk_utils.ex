defmodule AOC.Day09.DiskUtils do
  @doc ~S"""
  Count how many blocks on a disk have been used.

  ## Example

    iex> disk = [{0, 1}, {:empty, 2}, {1, 3}, {:empty, 4}, {2, 5}]
    iex> AOC.Day09.DiskUtils.count_blocks(disk)
    {9, 6}
  """
  def count_blocks(disk) do
    Enum.reduce(disk, {0, 0}, &count_blocks/2)
  end

  defp count_blocks({:empty, size}, {used, free}) do
    {used, free + size}
  end

  defp count_blocks({_, size}, {used, free}) do
    {used + size, free}
  end

  @doc ~S"""
  Given a disk, split it at a point and return each side.

  The front has its order maintained, the back has its order reversed
  and the empty elements removed.

  """
  def split_at(disk, index) do
    acc = {0, [], []}
    {_, front, back} = Enum.reduce(disk, acc, &process_item(index, &1, &2))

    {Enum.reverse(front), back}
  end

  defp process_item(
         split_target,
         {:empty, size},
         {index, front, back}
       )
       when index >= split_target do
    {index + size, front, back}
  end

  defp process_item(
         split_target,
         {id, size},
         {index, front, back}
       )
       when index >= split_target do
    {index + size, front, [{id, size} | back]}
  end

  defp process_item(
         split_target,
         {id, size},
         {index, front, back}
       )
       when index + size > split_target do
    head_size = split_target - index
    tail_size = size - head_size

    {index + size, [{id, head_size} | front], [{id, tail_size} | back]}
  end

  defp process_item(
         _,
         {_, size} = item,
         {index, front, back}
       ) do
    {index + size, [item | front], back}
  end

  @doc ~S"""
  Given a disk, compact it according to the rules in part A.

  ## Example

    iex> disk = [{0, 1}, {:empty, 2}, {1, 3}, {:empty, 4}, {2, 5}]
    iex> AOC.Day09.DiskUtils.compact_disk(disk)
    [{0, 1}, {2, 2}, {1, 3}, {2, 3}, {:empty, 6}]
  """
  def compact_disk(disk) do
    {used, free} = count_blocks(disk)

    {front, back} = split_at(disk, used)

    {compacted, _} = Enum.flat_map_reduce(front, back, &emit_block/2)

    Enum.concat(compacted, [{:empty, free}])
  end

  defp emit_block({:empty, empty_size}, [{id, size} | back]) do
    cond do
      empty_size == size ->
        {[{id, size}], back}

      empty_size < size ->
        {[{id, empty_size}], [{id, size - empty_size} | back]}

      empty_size > size ->
        {blocks, back} = emit_block({:empty, empty_size - size}, back)

        {[{id, size} | blocks], back}
    end
  end

  defp emit_block(block, back) do
    {[block], back}
  end

  @doc ~S"""
  Computes the checksum of a disk as per rules in part A.

  ## Example

    iex> disk = [{0, 1}, {2, 2}, {1, 3}, {2, 3}, {:empty, 6}]
    iex> AOC.Day09.DiskUtils.checksum(disk)
    60
  """
  def checksum(disk) do
    as_blocks(disk)
    |> Stream.with_index()
    |> Stream.map(&checksum_block/1)
    |> Enum.sum()
  end

  defp checksum_block({:empty, _}) do
    0
  end

  defp checksum_block({id, position}) do
    id * position
  end

  @doc ~S"""
  Given a disk, emit as a stream of blocks.
  """
  def as_blocks(disk) do
    Stream.flat_map(disk, &to_blocks/1)
  end

  defp to_blocks({id, size}) do
    1..size |> Enum.map(fn _ -> id end)
  end

  def defragmented_compact(disk) do
    # We want to take each file from the end and move it to the first
    # available space. This sucks in Elixir.
    #
    # We ca{:ok, n} start with a fold from the right with positions. But e
    # also need to maintain an index of the free space, with positions.
    #
    # Then it becomes a "put things in boxes" exercise.
    #
    # For each file:
    #
    # Find free space.
    # If found:
    #   Add file to moved map.
    #   Pop free space.
    #   Put new free space if remainder

    %{true: empty, false: files} =
      with_positions(disk)
      |> Enum.group_by(&is_empty?/1)

    {new_positions, _} =
      Enum.reverse(files)
      |> Enum.reduce({[], empty}, fn {file, position}, {files, empty} ->
        {new_position, new_empty} = move_file_to_free_space(empty, {file, position})

        case new_position do
          nil -> {[{file, position} | files], new_empty}
          new_position -> {[{file, new_position} | files], new_empty}
        end
      end)

    new_positions
  end

  defp with_positions(disk) do
    {result, _} =
      Enum.map_reduce(disk, 0, fn {_, size} = block, acc ->
        {{block, acc}, acc + size}
      end)

    result
  end

  defp is_empty?({{:empty, _}, _}), do: true
  defp is_empty?(_), do: false

  defp move_file_to_free_space([], _) do
    {nil, []}
  end

  defp move_file_to_free_space(
         [{{:empty, empty_size}, empty_position} | tail],
         {_, position}
       )
       when position < empty_position do
    {nil, [{{:empty, empty_size}, empty_position} | tail]}
  end

  defp move_file_to_free_space(
         [{{:empty, empty_size}, empty_position} | tail],
         {{_, size}, _}
       )
       when size == empty_size do
    {empty_position, tail}
  end

  defp move_file_to_free_space(
         [{{:empty, empty_size}, empty_position} | tail],
         {{_, size}, _}
       )
       when size < empty_size do
    {empty_position, [{{:empty, empty_size - size}, empty_position + size} | tail]}
  end

  defp move_file_to_free_space(
         [{{:empty, empty_size}, _} = space | tail],
         {{_, size}, _} = file
       )
       when size > empty_size do
    {empty_position, new_tail} = move_file_to_free_space(tail, file)

    case empty_position do
      nil -> {nil, [space | new_tail]}
      pos -> {pos, [space | new_tail]}
    end
  end

  def checksum_from_positions(positions) do
    Enum.reduce(positions, 0, fn {{id, size}, position}, sum ->
      weight = (position + (position + size - 1)) / 2

      sum + Kernel.round(size * id * weight)
    end)
  end
end
