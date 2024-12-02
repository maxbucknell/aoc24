defmodule AOC do
  def solve(day, part) do
    with {:ok, module} <- get_day(day),
         {:ok, function} <- get_part(part) do
      args = [IO.stream(:stdio, :line)]

      try do
        apply(module, function, args)
      rescue
        _ in UndefinedFunctionError -> {:error, :invalid_part}
      end
    end
  end

  @solutions %{
    1 => AOC.Day01,
    2 => AOC.Day02
  }

  defp get_day(day) do
    with {n, ""} <- Integer.parse(day, 10),
         {:ok, module} <- Map.fetch(@solutions, n) do
      {:ok, module}
    else
      _ -> {:error, :invalid_day}
    end
  end

  defp get_part(part) do
    case part do
      "a" -> {:ok, :a}
      "b" -> {:ok, :b}
      _ -> {:error, :invalid_part}
    end
  end
end
