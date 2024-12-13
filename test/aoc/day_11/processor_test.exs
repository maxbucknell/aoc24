defmodule AOC.Day11.ProcessorTest do
  use ExUnit.Case, async: true

  alias AOC.Day11.Processor

  test "process" do
    assert Processor.process(0) == [1]

    assert Processor.process(17) == [1, 7]

    assert Processor.process(125) == [253_000]
  end
end
