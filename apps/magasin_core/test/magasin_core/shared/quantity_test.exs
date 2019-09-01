defmodule MagasinCore.QuantityTest do
  use MagasinCore.TestCase

  alias MagasinCore.Quantity

  describe "subtracting two quantities" do
    test "returns a new quantity" do
      lhs = Quantity.new!(10)
      rhs = Quantity.new!(3)

      {:ok, quantity} = Quantity.subtract(lhs, rhs)

      assert Quantity.new!(7) == quantity
    end
  end
end
