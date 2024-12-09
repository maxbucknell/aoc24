defmodule Mix.Tasks.Bench do
  use Mix.Task

  def run(args) do
    with {:ok, opts, [day, part]} <- parse_options(args) do
      _is_verbose? = Keyword.get(opts, :verbose, false)

      Application.ensure_all_started([:httpoison])
      AOC.benchmark(day, part)
    else
      _ -> Process.exit(self(), :invalid_arguments)
    end
  end

  defp parse_options(args) do
    parsed =
      OptionParser.parse(
        args,
        strict: [verbose: :boolean],
        aliases: [v: :verbose]
      )

    with {opts, [day | args], []} <- parsed,
         {day, ""} <- Integer.parse(day) do
      {:ok, opts, [day | args]}
    else
      _ -> {:error, :invalid_arguments}
    end
  end
end
