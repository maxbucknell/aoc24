defmodule AOC.Day03.Parser do
  def parse(_, "m") do
    {:m}
  end

  def parse({:m}, "u") do
    {:mu}
  end

  def parse({:mu}, "l") do
    {:mul}
  end

  def parse(_, _) do
    nil
  end
end
