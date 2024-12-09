defmodule Mix.Tasks.Solve do
  use Mix.Task

  def run([day, part]) do
    answer =
      with {:ok, {day, part}} <- parse_args(day, part) do
        AOC.solve(day, part)
      end

    case answer do
      {:ok, answer} -> IO.puts(answer)
      {:error, error} -> Process.exit(self(), error)
    end
  end

  def run([day, part, filename]) do
    answer =
      with {:ok, {day, part}} <- parse_args(day, part) do
        AOC.solve(day, part, filename)
      end

    case answer do
      {:ok, answer} -> IO.puts(answer)
      {:error, error} -> Process.exit(self(), error)
    end
  end

  def run(_) do
    Process.exit(self(), :invalid_arguments)
  end

  defp parse_args(day, part) do
    with {day, ""} <- Integer.parse(day) do
      {:ok, {day, part}}
    else
      _ -> {:error, :invalid_arguments}
    end
  end
end
