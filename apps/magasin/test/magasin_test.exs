defmodule MagasinTest do
  use ExUnit.Case
  doctest Magasin

  test "greets the world" do
    assert Magasin.hello() == :world
  end
end
