defmodule MagasinCore.SalesFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias MagasinCore.Sales

      def sales_order_id_factory do
        Sales.OrderRepository.next_id()
      end

      def sales_order_factory do
        Sales.Order.new(
          id: build(:sales_order_id),
          email: build(:email),
          product_id: build(:catalog_product_id),
          quantity: build(:quantity)
        )
      end
    end
  end
end
