defmodule AOC.Day03.Parser.B do
  def parse(_, "d") do
    {:d}
  end

  def parse({:d}, "o") do
    {:do}
  end

  def parse({:do}, "n") do
    {:don}
  end

  def parse({:do}, "(") do
    {:do, "("}
  end

  def parse({:do, "("}, ")") do
    # Remove the :disabled flag
    nil
  end

  def parse({:don}, "'") do
    {:don_}
  end

  def parse({:don_}, "t") do
    {:don_t}
  end

  def parse({:don_t}, "(") do
    {:don_t, "("}
  end

  def parse({:don_t, "("}, ")") do
    :disable
  end

  def parse(:disable, "m") do
    :disable
  end

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

  def parse(:disable, _) do
    :disable
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
