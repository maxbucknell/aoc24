defmodule AOC do
  def solve(day, part, filename, mode \\ :stream) do
    input =
      case mode do
        :stream -> File.stream!(filename, :line)
        :load -> File.read!(filename) |> String.split("\n")
      end

    run_solution(day, part, input)
  end

  def solve(day, part) do
    input = IO.stream(:stdio, :line)

    run_solution(day, part, input)
  end

  def run_solution(day, part, input) do
    with {:ok, module} <- get_implementation(day),
         {:ok, function} <- get_part(part) do
      try do
        apply(module, function, [input])
      rescue
        _ in UndefinedFunctionError -> {:error, :not_implemented_yet}
      end
    end
  end

  defp get_implementation(day) when 0 < day and day <= 25 do
    key = "Elixir.AOC.Day" <> get_day(day)

    {:ok, String.to_existing_atom(key)}
  end

  defp get_implementation(_) do
    {:error, :invalid_day}
  end

  defp get_day(day) do
    Integer.to_string(day) |> String.pad_leading(2, "0")
  end

  defp get_part("a") do
    {:ok, :a}
  end

  defp get_part("b") do
    {:ok, :b}
  end

  defp get_part(_) do
    {:error, :invalid_part}
  end
end
