defmodule AOC.Day15 do
  alias AOC.Day15.State
  alias AOC.Day15.Parser

  @doc ~S"""
  Day 15, Part A

  We can parse each line and generate a data structure. Each room line
  adds walls and boxes to a sparse map, and each programme line moves
  the robot forward.

  ## Example

    iex> input = [
    ...>   "########\n",
    ...>   "#..O.O.#\n",
    ...>   "##@.O..#\n",
    ...>   "#...O..#\n",
    ...>   "#.#.O..#\n",
    ...>   "#...O..#\n",
    ...>   "#......#\n",
    ...>   "########\n",
    ...>   "\n",
    ...>   "<^^>>>vv<v>>v<<\n",
    ...> ]
    iex> a(input)
    {:ok, 2028}

    iex> input = [
    ...>   "##########\n",
    ...>   "#..O..O.O#\n",
    ...>   "#......O.#\n",
    ...>   "#.OO..O.O#\n",
    ...>   "#..O@..O.#\n",
    ...>   "#O#..O...#\n",
    ...>   "#O..O..O.#\n",
    ...>   "#.OO.O.OO#\n",
    ...>   "#....O...#\n",
    ...>   "##########\n",
    ...>   "\n",
    ...>   "<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^\n",
    ...>   "vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v\n",
    ...>   "><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<\n",
    ...>   "<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^\n",
    ...>   "^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><\n",
    ...>   "^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^\n",
    ...>   ">^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^\n",
    ...>   "<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>\n",
    ...>   "^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>\n",
    ...>   "v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^\n",
    ...> ]
    iex> a(input)
    {:ok, 10092}
  """
  @spec a(Enumerable.t(String.t())) :: {:ok, integer()} | {:error, atom()}
  def a(input) do
    result =
      Stream.flat_map(input, &String.graphemes/1)
      |> Enum.reduce({%State{}, 0, 0}, &Parser.process/2)
      |> elem(0)
      |> State.gps()

    {:ok, result}
  end
end
