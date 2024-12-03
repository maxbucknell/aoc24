defmodule AOC.Day03.Parser.A do
  def parse(_, "m") do
    {:m}
  end

  def parse({:m}, "u") do
    {:mu}
  end

  def parse({:mu}, "l") do
    {:mul}
  end

  def parse({:mul}, "(") do
    {:mul, "("}
  end

  def parse({:mul, "("}, x) do
    case take_digit(x) do
      nil -> nil
      n -> {:mul, "(", n}
    end
  end

  def parse({:mul, "(", a}, ",") when is_integer(a) do
    {:mul, "(", a, ","}
  end

  def parse({:mul, "(", a}, x) when is_integer(a) do
    case take_digit(x) do
      nil -> nil
      n -> {:mul, "(", a * 10 + n}
    end
  end

  def parse({:mul, "(", a, ","}, x) when is_integer(a) do
    case take_digit(x) do
      nil -> nil
      n -> {:mul, "(", a, ",", n}
    end
  end

  def parse({:mul, "(", a, ",", b}, ")") when is_integer(a) and is_integer(b) do
    {:val, a * b}
  end

  def parse({:mul, "(", a, ",", b}, x) when is_integer(a) and is_integer(b) do
    case take_digit(x) do
      nil -> nil
      n -> {:mul, "(", a, ",", b * 10 + n}
    end
  end

  def parse(_, _) do
    nil
  end

  defp take_digit(x) do
    case Integer.parse(x) do
      {n, ""} -> n
      _ -> nil
    end
  end
end
