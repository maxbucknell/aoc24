defmodule AOC.Day02.Reactor do
  alias AOC.Day02.Reactor.Reading
  defstruct readings: []

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
