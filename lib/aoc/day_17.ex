defmodule AOC.Day17 do
  @doc ~S"""
  Day 17, Part A

  ## Examples

    iex> input = [
    ...>   "Register A: 729\n",
    ...>   "Register B: 0\n",
    ...>   "Register C: 0\n",
    ...>   "\n",
    ...>   "Program: 0,1,5,4,3,0\n"
    ...> ]
    iex> a(input)
    {:ok, "4,6,3,5,6,3,5,2,1,0"}
  """
  def a(input) do
    {registers, programme} = AOC.Day17.Parser.parse(input)

    result = AOC.Day17.Computer.execute(programme, registers)

    {:ok, Enum.join(result, ",")}
  end
end

defmodule AOC.Day17.Parser do
  alias AOC.Day17.Computer

  @type state() :: {Computer.registers(), Computer.programme()}

  @doc ~S"""
  Parse puzzle input for Day 17.

  ## Example

    iex> input = [
    ...>   "Register A: 729\n",
    ...>   "Register B: 0\n",
    ...>   "Register C: 0\n",
    ...>   "\n",
    ...>   "Program: 0,1,5,4,3,0\n"
    ...> ]
    iex> parse(input)
    {
      {729, 0, 0},
      %{
        0 => 0,
        1 => 1,
        2 => 5,
        3 => 4,
        4 => 3,
        5 => 0
      }
    }
  """
  @spec parse(Enumerable.t(String.t())) :: state()
  def parse(input) do
    Enum.reduce(input, {{0, 0, 0}, %{}}, &parse_line(&2, &1))
  end

  @doc ~S"""
  Parse a single line of input.
  """
  @spec parse_line(state(), String.t()) :: state()
  def parse_line(input, line)

  def parse_line({{_, b, c}, programme}, "Register A: " <> value) do
    a = String.trim(value) |> String.to_integer()

    {{a, b, c}, programme}
  end

  def parse_line({{a, _, c}, programme}, "Register B: " <> value) do
    b = String.trim(value) |> String.to_integer()

    {{a, b, c}, programme}
  end

  def parse_line({{a, b, _}, programme}, "Register C: " <> value) do
    c = String.trim(value) |> String.to_integer()

    {{a, b, c}, programme}
  end

  def parse_line({registers, _}, "Program: " <> value) do
    programme =
      String.trim(value)
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {v, k}, programme -> Map.put(programme, k, v) end)

    {registers, programme}
  end

  def parse_line(input, _), do: input
end

defmodule AOC.Day17.Computer do
  @type register() :: integer()
  @type registers() :: {register(), register(), register()}
  @type instruction() :: integer()
  @type pointer() :: integer()

  @type state() :: {registers(), integer() | nil, pointer()}

  @type programme() :: %{optional(integer()) => integer()}

  @doc ~S"""
  Run a programme.

  ## Examples

    iex> programme = %{
    ...>   0 => 5,
    ...>   1 => 0,
    ...>   2 => 5,
    ...>   3 => 1,
    ...>   4 => 5,
    ...>   5 => 4
    ...> }
    iex> execute(programme, {10, 0, 0})
    [0, 1, 2]
    iex> programme = %{
    ...>   0 => 0,
    ...>   1 => 1,
    ...>   2 => 5,
    ...>   3 => 4,
    ...>   4 => 3,
    ...>   5 => 0,
    ...> }
    iex> execute(programme, {2024, 0, 0})
    [4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0]
  """
  def execute(programme, registers, instruction \\ 0, output \\ []) do
    with {:ok, opcode} <- Map.fetch(programme, instruction),
         {:ok, operand} <- Map.fetch(programme, instruction + 1) do
      {registers, new_output, instruction} = process(registers, instruction, opcode, operand)

      output =
        if new_output do
          [new_output | output]
        else
          output
        end

      execute(programme, registers, instruction, output)
    else
      _ -> Enum.reverse(output)
    end
  end

  @adv 0
  @bxl 1
  @bst 2
  @jnz 3
  @bxc 4
  @out 5
  @bdv 6
  @cdv 7

  @doc ~S"""
  Process a single instruction.

  ## Examples

    iex> process({16, 0, 0}, 4, 0, 2)
    {{4, 0, 0}, nil, 6}
    iex> process({16, 4, 0}, 10, 0, 5)
    {{1, 4, 0}, nil, 12}
    iex> process({0, 0, 9}, 0, 2, 6)
    {{0, 1, 9}, nil, 2}
    iex> process({0, 29, 0}, 0, 1, 7)
    {{0, 26, 0}, nil, 2}
    iex> process({0, 2024, 43690}, 0,  4, 0)
    {{0, 44354, 43690}, nil, 2}
  """
  @spec process(registers(), pointer(), instruction(), instruction()) :: state()
  def process(registers, instruction_pointer, opcode, operand)

  def process({a, b, c}, i, @adv, operand) do
    operand = combo({a, b, c}, operand)
    a = div(a, 2 ** operand)

    {{a, b, c}, nil, i + 2}
  end

  def process({a, b, c}, i, @bxl, operand) do
    b = Bitwise.bxor(b, operand)

    {{a, b, c}, nil, i + 2}
  end

  def process({a, b, c}, i, @bst, operand) do
    operand = combo({a, b, c}, operand)
    b = rem(operand, 8)

    {{a, b, c}, nil, i + 2}
  end

  def process({0, b, c}, i, @jnz, _), do: {{0, b, c}, nil, i + 2}

  def process({a, b, c}, _, @jnz, operand) do
    {{a, b, c}, nil, operand}
  end

  def process({a, b, c}, i, @bxc, _) do
    b = Bitwise.bxor(b, c)

    {{a, b, c}, nil, i + 2}
  end

  def process(registers, i, @out, operand) do
    operand = combo(registers, operand)

    out = rem(operand, 8)

    {registers, out, i + 2}
  end

  def process({a, b, c}, i, @bdv, operand) do
    operand = combo({a, b, c}, operand)
    b = div(a, 2 ** operand)

    {{a, b, c}, nil, i + 2}
  end

  def process({a, b, c}, i, @cdv, operand) do
    operand = combo({a, b, c}, operand)
    c = div(a, 2 ** operand)

    {{a, b, c}, nil, i + 2}
  end

  @doc ~S"""
  Convert combo operand to value.

  ## Examples

    iex> registers = {9, 10, 11}
    iex> combo(registers, 0)
    0
    iex> combo(registers, 1)
    1
    iex> combo(registers, 2)
    2
    iex> combo(registers, 3)
    3
    iex> combo(registers, 4)
    9
    iex> combo(registers, 5)
    10
    iex> combo(registers, 6)
    11
  """
  def combo(registers, operand)
  def combo(_registers, operand) when 0 <= operand and operand < 4, do: operand
  def combo({a, _, _}, 4), do: a
  def combo({_, b, _}, 5), do: b
  def combo({_, _, c}, 6), do: c
  def combo(_, _), do: nil
end
