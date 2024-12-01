defmodule Mix.Tasks.Solve do
  use Mix.Task

  def run(args) do
    [day, part] = args

    case AOC.solve(day, part) do
      {:ok, answer} -> IO.puts(answer)
      {:error, error} -> Process.exit(self(), error)
    end
  end
end
