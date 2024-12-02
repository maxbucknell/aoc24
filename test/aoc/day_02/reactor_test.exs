defmodule AOC.Day02.ReactorTest do
  use ExUnit.Case, async: true

  alias AOC.Day02.Reactor

  doctest AOC.Day02.Reactor

  test "no damping" do
    reactor = Reactor.new()

    assert {:ok, reactor} = Reactor.register(reactor, 6)

    assert {:error, :unsafe_level} = Reactor.register(reactor, 6)

    assert {:ok, reactor} = Reactor.register(reactor, 5)

    assert {:error, :unsafe_level} = Reactor.register(reactor, 6)
  end
end
