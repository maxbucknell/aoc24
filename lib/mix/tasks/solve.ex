defmodule Mix.Tasks.Solve do
  use Mix.Task

  def run([day, part]) do
    case AOC.solve(day, part) do
      {:ok, answer} -> IO.puts(answer)
      {:error, error} -> Process.exit(self(), error)
    end
  end

  def run([day, part, filename]) do
    case AOC.solve(day, part, filename) do
      {:ok, answer} -> IO.puts(answer)
      {:error, error} -> Process.exit(self(), error)
    end
  end
end
