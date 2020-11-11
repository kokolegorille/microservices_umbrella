defmodule FileStoreTest do
  use ExUnit.Case
  doctest FileStore

  test "greets the world" do
    assert FileStore.hello() == :world
  end
end
