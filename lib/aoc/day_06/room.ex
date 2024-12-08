defmodule AOC.Day06.Room do
  defstruct width: 0, height: 0, rows: %{}, cols: %{}

  @doc ~S"""
  Add an obstacle to a room.

  THIS ONLY WORKS IF YOU ARE SEQUENTIALLY ADDING OBSTACLES

  The entire implementation of this solution depends on the indices of
  the rows and columns being sorted in descending order. If this is not
  true, I don't know what would happen, but it ain't good.

  I could fix this by sorting them at every addition, but I cbf to do
  that when I also control the creation mechanism.
  """
  def add_obstacle(room, x, y) do
    %__MODULE__{
      width: max(room.width, x + 1),
      height: max(room.height, y + 1),
      rows: Map.update(room.rows, y, [x], &[x | &1]),
      cols: Map.update(room.cols, x, [y], &[y | &1])
    }
  end

  def add_space(room, x, y) do
    %__MODULE__{
      width: max(room.width, x + 1),
      height: max(room.height, y + 1),
      rows: room.rows,
      cols: room.cols
    }
  end

  def next_obstacle(room, {x, y, :up}) do
    col = Map.get(room.cols, x, [])

    obstacle_y = Enum.find(col, nil, &(&1 < y))

    case obstacle_y do
      nil -> nil
      y -> {x, y}
    end
  end

  def next_obstacle(room, {x, y, :right}) do
    row = Map.get(room.rows, y, [])

    obstacle_x =
      Enum.reduce_while(row, nil, fn curr, prev ->
        if curr < x do
          {:halt, prev}
        else
          {:cont, curr}
        end
      end)

    case obstacle_x do
      nil -> nil
      x -> {x, y}
    end
  end

  def next_obstacle(room, {x, y, :down}) do
    col = Map.get(room.cols, x, [])

    obstacle_y =
      Enum.reduce_while(col, nil, fn curr, prev ->
        if curr < y do
          {:halt, prev}
        else
          {:cont, curr}
        end
      end)

    case obstacle_y do
      nil -> nil
      y -> {x, y}
    end
  end

  def next_obstacle(room, {x, y, :left}) do
    row = Map.get(room.rows, y, [])

    obstacle_x = Enum.find(row, nil, &(&1 < x))

    case obstacle_x do
      nil -> nil
      x -> {x, y}
    end
  end

  def move_to_obstacle(_room, {ox, oy}, {gx, gy, :up}) do
    dest = {ox, oy + 1}
    {dest, get_visted_nodes({gx, gy}, dest)}
  end

  def move_to_obstacle(_room, {ox, oy}, {gx, gy, :right}) do
    dest = {ox - 1, oy}
    {dest, get_visted_nodes({gx, gy}, dest)}
  end

  def move_to_obstacle(_room, {ox, oy}, {gx, gy, :down}) do
    dest = {ox, oy - 1}
    {dest, get_visted_nodes({gx, gy}, dest)}
  end

  def move_to_obstacle(_room, {ox, oy}, {gx, gy, :left}) do
    dest = {ox + 1, oy}
    {dest, get_visted_nodes({gx, gy}, dest)}
  end

  def move_to_obstacle(_room, nil, {gx, gy, :up}) do
    dest = {gx, 0}
    {dest, get_visted_nodes({gx, gy}, dest)}
  end

  def move_to_obstacle(room, nil, {gx, gy, :right}) do
    dest = {room.width - 1, gy}
    {dest, get_visted_nodes({gx, gy}, dest)}
  end

  def move_to_obstacle(room, nil, {gx, gy, :down}) do
    dest = {gx, room.height - 1}
    {dest, get_visted_nodes({gx, gy}, dest)}
  end

  def move_to_obstacle(_room, nil, {gx, gy, :left}) do
    dest = {0, gy}
    {dest, get_visted_nodes({gx, gy}, dest)}
  end

  defp get_visted_nodes({ox, oy}, {dx, dy}) when ox == dx do
    case oy > dy do
      true -> oy..dy//-1 |> Enum.map(&{ox, &1}) |> MapSet.new()
      false -> oy..dy//1 |> Enum.map(&{ox, &1}) |> MapSet.new()
    end
  end

  defp get_visted_nodes({ox, oy}, {dx, dy}) when oy == dy do
    case ox > dx do
      true -> ox..dx//-1 |> Enum.map(&{&1, oy}) |> MapSet.new()
      false -> ox..dx//1 |> Enum.map(&{&1, oy}) |> MapSet.new()
    end
  end
end
