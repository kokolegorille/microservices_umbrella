defmodule AuthenticationTest do
  use ExUnit.Case
  doctest Authentication

  test "greets the world" do
    assert Authentication.hello() == :world
  end
end
