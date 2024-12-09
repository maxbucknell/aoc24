defmodule Mix.Tasks.Solve do
  use Mix.Task

  def run(args) do
    with {:ok, opts, args} <- parse_options(args) do
      is_load? = Keyword.get(opts, :load, false)
      _is_verbose? = Keyword.get(opts, :verbose, false)

      case get_answer(is_load?, args) do
        {:ok, answer} -> IO.puts(answer)
        {:error, error} -> Process.exit(self(), error)
      end
    else
      _ -> Process.exit(self(), :invalid_arguments)
    end
  end

  defp parse_options(args) do
    parsed =
      OptionParser.parse(
        args,
        strict: [verbose: :boolean, load: :boolean],
        aliases: [v: :verbose, l: :load]
      )

    with {opts, [day | args], []} <- parsed,
         {day, ""} <- Integer.parse(day) do
      {:ok, opts, [day | args]}
    else
      _ -> {:error, :invalid_arguments}
    end
  end

  defp get_answer(is_load?, [day, part]) when is_load? do
    Application.ensure_all_started([:httpoison])
    AOC.load_and_solve(day, part)
  end

  defp get_answer(is_load?, [day, part]) when not is_load? do
    AOC.solve(day, part)
  end

  defp get_answer(_, [day, part, "-"]) do
    AOC.solve(day, part)
  end

  defp get_answer(_, [day, part, filename]) do
    AOC.solve(day, part, filename)
  end
end
