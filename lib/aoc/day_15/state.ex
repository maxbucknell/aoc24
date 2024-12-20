defmodule AOC.Day15.State do
  defstruct objects: %{}, robot: {0, 0}, dimensions: {0, 0}

  import AOC.Utils.Geometry, only: [neighbour: 2, largest: 2]

  @type point() :: {integer(), integer()}
  @type t() :: %__MODULE__{
          objects: %{optional(point()) => :wall | :box},
          robot: point()
        }

  def get(state, point) do
    Map.get(state.objects, point, :empty)
  end

  def push(state, direction) do
    point = state.robot
    new = neighbour(point, direction)

    object = get(state, new)

    case push_impl(state, new, object, direction) do
      {:ok, state} -> %__MODULE__{state | robot: new}
      {:error, state} -> state
    end
  end

  defp push_impl(state, _point, :empty, _direction) do
    {:ok, state}
  end

  defp push_impl(state, _point, :wall, _direction) do
    {:error, state}
  end

  defp push_impl(state, point, :box, direction) do
    new = neighbour(point, direction)
    object = get(state, new)

    case push_impl(state, new, object, direction) do
      {:ok, state} ->
        objects = Map.delete(state.objects, point) |> Map.put(new, :box)
        {:ok, %__MODULE__{state | objects: objects}}

      {:error, state} ->
        {:error, state}
    end
  end

  def add_wall(state, point) do
    objects = Map.put_new(state.objects, point, :wall)

    {w, h} = point

    dimensions = largest({w + 1, h + 1}, state.dimensions)

    %__MODULE__{state | objects: objects, dimensions: dimensions}
  end

  def add_box(state, point) do
    objects = Map.put_new(state.objects, point, :box)

    %__MODULE__{state | objects: objects}
  end

  def position_robot(state, point) do
    %__MODULE__{state | robot: point}
  end

  def gps(state) do
    Enum.map(state.objects, &gps_of_point/1)
    |> Enum.sum()
  end

  defp gps_of_point({{x, y}, :box}) do
    100 * y + x
  end

  defp gps_of_point(_) do
    0
  end

  def print(state) do
    {width, height} = state.dimensions

    Enum.each(0..(height - 1), fn y ->
      Enum.each(0..(width - 1), fn x ->
        char =
          if {x, y} == state.robot do
            "@"
          else
            case get(state, {x, y}) do
              :empty -> "."
              :wall -> "#"
              :box -> "O"
            end
          end

        IO.write(char)
      end)

      IO.write("\n")
    end)

    IO.write("\n")

    state
  end
end
