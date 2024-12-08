defmodule AOC.Day06.Room do
  defstruct width: 0, height: 0, rows: %{}, cols: %{}

  @doc ~S"""
  Add an obstacle to a room.
  """
  def add_obstacle(room, x, y) do
    %__MODULE__{
      width: max(room.width, x + 1),
      height: max(room.height, y + 1),
      rows: Map.update(room.rows, y, [x], &insert_entry(&1, x)),
      cols: Map.update(room.cols, x, [y], &insert_entry(&1, y))
    }
  end

  defp insert_entry(vals, val) do
    i =
      case Enum.find_index(vals, &(&1 <= val)) do
        nil -> -1
        i -> i
      end

    List.insert_at(vals, i, val) |> Enum.uniq()
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
      true -> oy..dy//-1 |> Enum.map(&{ox, &1})
      false -> oy..dy//1 |> Enum.map(&{ox, &1})
    end
  end

  defp get_visted_nodes({ox, oy}, {dx, dy}) when oy == dy do
    case ox > dx do
      true -> ox..dx//-1 |> Enum.map(&{&1, oy})
      false -> ox..dx//1 |> Enum.map(&{&1, oy})
    end
  end
end
