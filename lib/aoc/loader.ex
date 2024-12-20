defmodule AOC.Loader do
  @doc ~S"""
  Load puzzle input from online for automated running
  """
  def load_input(number) do
    with {:ok, url} <- get_url(number),
         {:ok, headers} <- get_headers(),
         {:ok, response} <- HTTPoison.get(url, headers) do
      content =
        response.body
        |> String.split("\n")
        |> Enum.map(fn line -> line <> "\n" end)

      {:ok, content}
    end
  end

  defp get_url(number) when 0 < number and number <= 25 do
    {:ok, "https://adventofcode.com/2024/day/" <> Integer.to_string(number) <> "/input"}
  end

  defp get_url(_) do
    {:error, :invalid_day}
  end

  defp get_headers() do
    with {:ok, cookie} <- get_cookie() do
      {:ok, [Cookie: cookie]}
    end
  end

  defp get_cookie() do
    with {:ok, session_id} <- Application.fetch_env!(:aoc, :session_id) do
      {:ok, "session=" <> session_id}
    else
      _ -> {:error, :session_id_not_set}
    end
  end
end
