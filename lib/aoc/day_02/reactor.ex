defmodule AOC.Day02.Reactor do
  alias AOC.Day02.Reactor.Reading
  defstruct readings: []

  @moduledoc ~S"""
  Represents the red-node reactor.

  Register a new reading with the register function. Because we don't know if a
  reading is reliable, we track every possible valid reading until we know that
  it is unsafe, at which point it is removed. Then, when no safe candidate
  readings remain within the given dampening tolerance, we know the reactor is
  unsafe.
  """

  def new(dampener \\ 0) do
    %__MODULE__{
      readings: [Reading.new(dampener, [])]
    }
  end

  def register(reactor, level) do
    reactor.readings
    |> Enum.flat_map(fn reading -> Reading.register(reading, level) end)
    |> case do
      [] -> {:error, :unsafe_level}
      new_readings -> {:ok, %__MODULE__{readings: new_readings}}
    end
  end
end
