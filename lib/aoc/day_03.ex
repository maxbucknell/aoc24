defmodule AOC.Day03 do
  @doc ~S"""
    iex> AOC.Day03.a("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
    {:ok, 161}
  """
  def a(input) do
    input |> Enum.join(".") |> IO.puts()

    {:error, :not_implemented_yet}
  end
end
