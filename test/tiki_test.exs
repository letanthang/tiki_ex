defmodule TikiTest do
  use ExUnit.Case
  doctest Tiki

  test "greets the world" do
    assert Tiki.hello() == :world
  end
end
