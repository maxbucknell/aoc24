defmodule AOC.Day05.Fixer do
  def generate_valid_update(dependencies) when map_size(dependencies) == 0 do
    {:ok, []}
  end

  def generate_valid_update(dependencies) do
    first =
      Map.keys(dependencies)
      |> Enum.filter(fn k ->
        Map.fetch!(dependencies, k) == MapSet.new()
      end)

    case first == [] do
      true ->
        {:error, :invalid_rules}

      false ->
        dependencies =
          Map.drop(dependencies, first)
          |> Map.to_list()
          |> Enum.map(fn {k, v} ->
            new_set =
              Enum.reduce(first, v, fn x, acc ->
                MapSet.delete(acc, x)
              end)

            {k, new_set}
          end)
          |> Map.new()

        case generate_valid_update(dependencies) do
          {:ok, v} -> {:ok, first ++ v}
          {:error, error} -> {:error, error}
        end
    end
  end
end
