defmodule AOC.Day05.Processor do
  @doc ~S"""
  Reduce a single line of input, with a mode switcher.

  ## Dependencies

  The first part of the file is a list of dependencies, of the form:

    a|b

  Which means that if they both appear, a must be before b.

  We are going to collect a map of b -> a. That is to say, a map keyed
  by the pages that should come after, and the value is a set of pages
  that, if they are present, must precede the key.

  Later, we will check that no subsequent page is a member of the union
  of all of the sets belonging to the keys of the previous pages.

  ## Blank line

  A blank line signifies that the dependencies have ended, and we are
  now reading lists of page numbers.

  ## Updates

  Each update is a line of comma separated page numbers. Our algorithm
  is to take the dependencies above and progressively build a set of
  pages that, were they to show up in future, would make this update
  invalid.
  """
  def reduce_line("", %{mode: :dependencies} = state) do
    Map.put(state, :mode, :updates)
  end

  def reduce_line(line, %{mode: :dependencies} = state) do
    Map.update!(state, :dependencies, &parse_mapping(line, &1))
  end

  def reduce_line(line, %{mode: :updates} = state) do
    dependencies = state.dependencies

    numbers =
      String.split(line, ",", trim: true)
      |> Enum.map_reduce(0, fn x, n -> {String.to_integer(x), n + 1} end)

    key = if is_valid?(dependencies, numbers), do: :valid, else: :invalid

    Map.update(state, key, [numbers], &([numbers] ++ &1))
  end

  def is_valid?(dependencies, {numbers, _}) do
    Enum.reduce_while(numbers, MapSet.new(), fn x, invalid ->
      if MapSet.member?(invalid, x) do
        {:halt, false}
      else
        new_invalid = Map.get(dependencies, x, MapSet.new())
        {:cont, MapSet.union(invalid, new_invalid)}
      end
    end)
    |> case do
      false -> false
      _ -> true
    end
  end

  @doc ~S"""
  Take a mapping line x|y and return {x, y}

  ## Examples

    iex> AOC.Day05.Processor.parse_mapping("56|13")
    %{13 => MapSet.new([56])}
    iex> AOC.Day05.Processor.parse_mapping("111|92")
    %{92 => MapSet.new([111])}
  """
  def parse_mapping(s, dependencies \\ %{}) do
    [a, b] = String.split(s, "|", parts: 2, trim: true)
    {a, b} = {String.to_integer(a), String.to_integer(b)}

    Map.update(dependencies, b, MapSet.new([a]), &MapSet.put(&1, a))
  end
end
