defmodule AOC.Day16 do
  @doc ~S"""
  Day 16, Part A

  ## Example

    iex> input = [
    ...>   "###############\n",
    ...>   "#.......#....E#\n",
    ...>   "#.#.###.#.###.#\n",
    ...>   "#.....#.#...#.#\n",
    ...>   "#.###.#####.#.#\n",
    ...>   "#.#.#.......#.#\n",
    ...>   "#.#.#####.###.#\n",
    ...>   "#...........#.#\n",
    ...>   "###.#.#####.#.#\n",
    ...>   "#...#.....#.#.#\n",
    ...>   "#.#.#.###.#.#.#\n",
    ...>   "#.....#...#.#.#\n",
    ...>   "#.###.#.#.#.#.#\n",
    ...>   "#S..#.....#...#\n",
    ...>   "###############\n",
    ...> ]
    iex> a(input)
    {:ok, 7036}
  """
  def a(input) do
    input = AOC.Day16.Parser.parse(input)
    result = AOC.Day16.Solver.minimum_distance(input)

    {:ok, result}
  end
end

defmodule AOC.Day16.Input do
  alias AOC.Utils.Geometry

  defstruct graph: %{}, start: {0, 0}, end: {0, 0}

  @type value :: :wall | :space
  @type graph :: %{optional(Geometry.point()) => value()}
  @type t :: %__MODULE__{
          graph: graph(),
          start: {Geometry.point(), Geometry.direction()},
          end: Geometry.point()
        }
end

defmodule AOC.Day16.Solver do
  require Logger
  alias AOC.Utils.Geometry

  @directions %{0 => :up, 1 => :right, 2 => :down, 3 => :left}
  @opposite %{
    up: :down,
    right: :left,
    down: :up,
    left: :right
  }

  @doc ~S"""
  Find minimum distance from start to end.

  Uses a weird half version of Dijkstra's algorithm to do so.
  """
  def minimum_distance(state) do
    distances = %{state.start => 0}
    queue = :queue.new()
    queue = :queue.in(state.start, queue)

    distances = traverse(state, queue, distances)

    Map.values(@directions)
    |> Enum.map(&Map.get(distances, {state.end, &1}, :infinity))
    |> Enum.min()
  end

  @doc ~S"""
  From a point, find its neighbours, set their distances, and recurse.

  How do we know when we are finished? I don't think it is sufficient
  simply to wait until we call `traverse/3` on `end`, because another,
  longer route might have a lower cost.

  I suppose, when we get to end, we don't call it again, but other
  tails can still resolve. And the state distances gets returned, and
  we find the result.
  """
  def traverse(_state, {[], []}, distances) do
    distances
  end

  def traverse(state, queue, distances) do
    {value, queue} = :queue.out(queue)
    {:value, {point, direction}} = value
    distance = Map.fetch!(distances, {point, direction})

    new_nodes = find_next_nodes(state, {point, direction})

    new_distances =
      Enum.map(new_nodes, &{&1, distance + find_distance({point, direction}, &1)}) |> Map.new()

    {queue, distances} =
      Enum.filter(new_nodes, &(new_distances[&1] < Map.get(distances, &1, :infinity)))
      |> Enum.reduce({queue, distances}, fn new_node, {queue, distances} ->
        {:queue.in(new_node, queue), Map.put(distances, new_node, new_distances[new_node])}
      end)

    traverse(state, queue, distances)
  end

  def find_next_nodes(state, {point, direction}) do
    opposite = @opposite[direction]

    Geometry.adjacent_nodes(point)
    |> Enum.with_index()
    |> Enum.flat_map(fn {next, i} ->
      with :space <- Map.get(state.graph, next, :wall),
           new_direction when new_direction != opposite <- @directions[i],
           next_vertex when not is_nil(next_vertex) <- follow_corridor(state, next, new_direction) do
        [{next_vertex, new_direction}]
      else
        _ -> []
      end
    end)
  end

  @doc ~S"""
  Return the coordinate of the next junction.

  We are at the end of a corridor, if:

   - There are more than two exits, or
   - The space in front (in direction) is not an exit.
  """
  def follow_corridor(state, point, direction) do
    Geometry.adjacent_nodes(point)
    |> Enum.filter(&(Map.get(state.graph, &1, :wall) == :space))
    |> Enum.count()
    |> case do
      # Dead end, no node up here
      1 ->
        if point == state.end do
          point
        else
          nil
        end

      # Single path, one exit one entry
      2 ->
        next = Geometry.neighbour(point, direction)

        if Map.get(state.graph, next, :wall) == :space do
          # Straight line
          follow_corridor(state, next, direction)
        else
          # Corner, technically a junction
          point
        end

      # More than 2 exits, we are at a junction
      _ ->
        point
    end
  end

  def find_distance({point1, direction1}, {point2, direction2}) do
    case direction2 do
      ^direction1 -> find_naive_distance(point1, point2)
      _ -> 1000 + find_naive_distance(point1, point2)
    end
  end

  def find_naive_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end

defmodule AOC.Day16.Parser do
  alias AOC.Day16.Input
  alias AOC.Utils.Geometry

  @spec parse(Enumerable.t(String.t())) :: Input.t()
  def parse(input) do
    Stream.with_index(input)
    |> Enum.reduce(%Input{}, &parse_line/2)
  end

  @spec parse_line({String.t(), integer()}, Input.t()) :: Input.t()
  def parse_line({line, y}, state) do
    String.graphemes(line)
    |> Stream.with_index()
    |> Enum.reduce(state, &parse_char(&2, y, &1))
  end

  @spec parse_char(Input.t(), integer(), {String.t(), integer()}) :: Input.t()
  def parse_char(state, y, {".", x}) do
    %Input{
      state
      | graph: Map.put(state.graph, {x, y}, :space)
    }
  end

  def parse_char(state, y, {"#", x}) do
    %Input{
      state
      | graph: Map.put(state.graph, {x, y}, :wall)
    }
  end

  def parse_char(state, y, {"S", x}) do
    %Input{
      state
      | graph: Map.put(state.graph, {x, y}, :space),
        start: {{x, y}, :right}
    }
  end

  def parse_char(state, y, {"E", x}) do
    %Input{
      state
      | graph: Map.put(state.graph, {x, y}, :space),
        end: {x, y}
    }
  end

  def parse_char(state, _y, _value), do: state
end
