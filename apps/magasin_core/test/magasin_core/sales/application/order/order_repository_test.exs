defmodule MagasinCore.Sales.OrderRepositoryTest do
  use MagasinCore.TestCase

  alias CivilCode.RepositoryError

  alias MagasinCore.Sales.{OrderId, OrderRepository}

  @moduletag timeout: 1_000

  describe "saving an order" do
    test "valid order returns an order id" do
      valid_order = build_entity(:sales_order)

      {:ok, order_id} =
        OrderRepository.transaction(fn ->
          OrderRepository.save(valid_order)
        end)

      assert %OrderId{} = order_id
    end

    test "duplicate order id returns a repository error" do
      duplicate_order_id = OrderRepository.next_id()
      order_1 = build_entity(:sales_order, id: duplicate_order_id)

      {:ok, _order_id} =
        OrderRepository.transaction(fn ->
          OrderRepository.save(order_1)
        end)

      order_2 = build_entity(:sales_order, id: duplicate_order_id)

      {:error, repository_error} =
        OrderRepository.transaction(fn ->
          OrderRepository.save(order_2)
        end)

      assert %RepositoryError{} = repository_error
      assert :id == repository_error.field_name
      assert "has already been taken" == repository_error.message
    end
  end
end
