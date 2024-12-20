defmodule AOC.Day15.Parser do
  alias AOC.Day15.State

  @type acc() :: {State.t(), integer(), integer()}

  @wall "#"
  @box "O"
  @robot "@"

  @up "^"
  @right ">"
  @down "v"
  @left "<"

  @spec process(String.t(), acc()) :: acc()
  def process(character, state)

  def process(@wall, {state, x, y}) do
    {State.add_wall(state, {x, y}), x + 1, y}
  end

  def process(@box, {state, x, y}) do
    {State.add_box(state, {x, y}), x + 1, y}
  end

  def process(@robot, {state, x, y}) do
    {State.position_robot(state, {x, y}), x + 1, y}
  end

  def process("\n", {state, _, y}) do
    {state, 0, y + 1}
  end

  def process(@up, {state, x, y}) do
    {State.push(state, :up), x + 1, y}
  end

  def process(@right, {state, x, y}) do
    {State.push(state, :right), x + 1, y}
  end

  def process(@down, {state, x, y}) do
    {State.push(state, :down), x + 1, y}
  end

  def process(@left, {state, x, y}) do
    {State.push(state, :left), x + 1, y}
  end

  def process(_, {state, x, y}) do
    {state, x + 1, y}
  end
end
