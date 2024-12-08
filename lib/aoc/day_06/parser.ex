defmodule AOC.Day06.Parser do
  alias AOC.Day06.Room

  @obstacle "#"
  @guard_up "^"
  @guard_right ">"
  @guard_down "v"
  @guard_left "<"

  def parse(input) do
    Stream.with_index(input)
    |> Enum.reduce({%Room{}, nil}, fn {line, y}, state ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.reduce(state, fn {char, x}, state -> process_char(state, x, y, char) end)
    end)
  end

  def process_char({room, guard}, x, y, @obstacle) do
    {Room.add_obstacle(room, x, y), guard}
  end

  def process_char({room, _}, x, y, @guard_up) do
    {room, {x, y, :up}}
  end

  def process_char({room, _}, x, y, @guard_right) do
    {room, {x, y, :right}}
  end

  def process_char({room, _}, x, y, @guard_down) do
    {room, {x, y, :down}}
  end

  def process_char({room, _}, x, y, @guard_left) do
    {room, {x, y, :left}}
  end

  def process_char({room, guard}, x, y, _) do
    {Room.add_space(room, x, y), guard}
  end
end
