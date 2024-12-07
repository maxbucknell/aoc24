defmodule AOC.Day05 do
  @doc ~S"""
  Day 5, Part A

  We have some fun input parsing here, it comes in two parts. We need to
  consume stdin up to the first blank line, which we can do with a
  reduce_while, a beautiful function.

  We are going to store the dependencies as a map with the values being
  sets, but inverting them from the order we are given. That means that
  we can process each update by building a set of pages that are not
  allowed to appear _after_ the current page.

  ## Example

    iex> input = [
    ...>   "47|53",
    ...>   "97|13",
    ...>   "97|61",
    ...>   "97|47",
    ...>   "75|29",
    ...>   "61|13",
    ...>   "75|53",
    ...>   "29|13",
    ...>   "97|29",
    ...>   "53|29",
    ...>   "61|53",
    ...>   "97|53",
    ...>   "61|29",
    ...>   "47|13",
    ...>   "75|47",
    ...>   "97|75",
    ...>   "47|61",
    ...>   "75|61",
    ...>   "47|29",
    ...>   "75|13",
    ...>   "53|13",
    ...>   "",
    ...>   "75,47,61,53,29",
    ...>   "97,61,53,29,13",
    ...>   "75,29,13",
    ...>   "75,97,47,61,53",
    ...>   "61,13,29",
    ...>   "97,13,75,29,47",
    ...> ]
    iex> AOC.Day05.a(input)
    {:ok, 143}
  """
  def a(input) do
    acc = %{mode: :dependencies, dependencies: %{}, valid: [], invalid: []}

    result =
      input
      |> Stream.map(&String.trim/1)
      |> Enum.reduce(acc, &AOC.Day05.Processor.reduce_line/2)
      |> Map.get(:valid, [])
      |> Enum.reduce(0, fn {numbers, n}, sum ->
        middle = Enum.at(numbers, div(n - 1, 2))

        sum + middle
      end)

    {:ok, result}
  end

  @doc ~S"""
  Day 5, Part B

  ## Example

    iex> input = [
    ...>   "47|53",
    ...>   "97|13",
    ...>   "97|61",
    ...>   "97|47",
    ...>   "75|29",
    ...>   "61|13",
    ...>   "75|53",
    ...>   "29|13",
    ...>   "97|29",
    ...>   "53|29",
    ...>   "61|53",
    ...>   "97|53",
    ...>   "61|29",
    ...>   "47|13",
    ...>   "75|47",
    ...>   "97|75",
    ...>   "47|61",
    ...>   "75|61",
    ...>   "47|29",
    ...>   "75|13",
    ...>   "53|13",
    ...>   "",
    ...>   "75,47,61,53,29",
    ...>   "97,61,53,29,13",
    ...>   "75,29,13",
    ...>   "75,97,47,61,53",
    ...>   "61,13,29",
    ...>   "97,13,75,29,47",
    ...> ]
    iex> AOC.Day05.b(input)
    {:ok, 123}

  """
  def b(input) do
    acc = %{mode: :dependencies, dependencies: %{}, valid: [], invalid: []}

    acc =
      input
      |> Stream.map(&String.trim/1)
      |> Enum.reduce(acc, &AOC.Day05.Processor.reduce_line/2)

    result =
      Map.get(acc, :invalid, [])
      |> Enum.map(fn {numbers, n} ->
        set = MapSet.new(numbers)

        dependencies =
          Enum.reduce(numbers, %{}, fn x, dependencies ->
            rules =
              Map.get(acc.dependencies, x, MapSet.new())
              |> MapSet.intersection(set)

            Map.put(dependencies, x, rules)
          end)

        case AOC.Day05.Fixer.generate_valid_update(dependencies) do
          {:ok, v} -> {v, n}
        end
      end)
      |> Enum.reduce(0, fn {numbers, n}, sum ->
        middle = Enum.at(numbers, div(n - 1, 2))

        sum + middle
      end)

    {:ok, result}
  end
end
