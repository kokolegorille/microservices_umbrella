defmodule EmailerTest do
  use ExUnit.Case
  doctest Emailer

  test "greets the world" do
    assert Emailer.hello() == :world
  end
end
