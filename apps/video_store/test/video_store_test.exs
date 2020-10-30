defmodule VideoStoreTest do
  use ExUnit.Case
  doctest VideoStore

  test "greets the world" do
    assert VideoStore.hello() == :world
  end
end
