defmodule AOC do
  def solve(day, part) do
    with {:ok, module} <- get_day(day),
         {:ok, function} <- get_part(part) do
      args = get_args(module, function)

      try do
        apply(module, function, args)
      rescue
        _ in UndefinedFunctionError -> {:error, :invalid_part}
      end
    end
  end

  @solutions %{
    1 => AOC.Day01,
    2 => AOC.Day02,
    3 => AOC.Day03,
    4 => AOC.Day04,
    5 => AOC.Day05,
    6 => AOC.Day06
  }

  defp get_day(day) do
    with {n, ""} <- Integer.parse(day, 10),
         {:ok, module} <- Map.fetch(@solutions, n) do
      {:ok, module}
    else
      _ -> {:error, :invalid_day}
    end
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

  defp get_args(AOC.Day03, _) do
    [IO.stream(:stdio, 1)]
  end

  defp get_args(_, _) do
    [IO.stream(:stdio, :line)]
  end
end
