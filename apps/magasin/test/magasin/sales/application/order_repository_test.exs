defmodule Magasin.Sales.Application.OrderRepositoryTest do
  use Magasin.TestCase

  alias CivilCode.RepositoryError
  alias Magasin.Sales.Application.OrderRepository
  alias Magasin.Sales.Domain.OrderId

  describe "adding an order" do
    test "valid order returns an order id" do
      valid_order = build_entity(:sales_order)
      {:ok, order_id} = OrderRepository.add(valid_order)
      assert %OrderId{} = order_id
    end

    test "duplicate order id returns a repository error" do
      duplicate_order_id = OrderId.new!()
      order_1 = build_entity(:sales_order, id: duplicate_order_id)
      {:ok, _order_id} = OrderRepository.add(order_1)

      order_2 = build_entity(:sales_order, id: duplicate_order_id)
      {:error, repository_error} = OrderRepository.add(order_2)

      assert %RepositoryError{} = repository_error
      assert :id == repository_error.field_name
      assert "has already been taken" == repository_error.message
    end
  end
end
