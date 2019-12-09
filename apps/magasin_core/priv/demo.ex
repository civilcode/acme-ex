defmodule MagasinCore.Demo do
  @moduledoc """
  A demo for the event bus.

  Usage:

      c "apps/magasin_core/priv/demo.ex"
      MagasinCore.Demo.seed
      MagasinCore.Demo.run
      MagasinData.Repo.all(MagasinData.Inventory.StockItemRecord) |> List.last
  """

  alias MagasinCore.{Catalog, Inventory, Sales}

  @product_id Catalog.ProductRepository.next_id()
  @stock_item_id Inventory.StockItemRepository.next_id()

  def seed do
    MagasinData.Repo.insert!(%MagasinData.Inventory.StockItemRecord{
      id: @stock_item_id.value,
      product_id: @product_id.value,
      count_on_hand: 10
    })
  end

  def run do
    order_id = Sales.OrderRepository.next_id()

    command =
      Sales.PlaceOrder.new!(%{
        "order_id" => to_string(order_id),
        "email" => "foo@bar.com",
        "product_id" => to_string(@product_id),
        "quantity" => "1",
        "line_items" => [],
        "shipping_address" => %{
          "street_address" => "1 Main St",
          "city" => "Montreal",
          "postal_code" => "H2T1S6"
        }
      })

    _result = Sales.OrderApplicationService.handle(command)
  end

  def fail do
    order_id = Sales.OrderRepository.next_id()
    does_not_exist = Catalog.ProductRepository.next_id()

    command =
      Sales.PlaceOrder.new!(%{
        "order_id" => to_string(order_id),
        "email" => "foo@bar.com",
        "product_id" => to_string(does_not_exist),
        "quantity" => "1",
        "line_items" => [],
        "shipping_address" => %{
          "street_address" => "1 Main St",
          "city" => "Montreal",
          "postal_code" => "H2T1S6"
        }
      })

    _result = Sales.OrderApplicationService.handle(command)

    IO.puts("run: MagasinCore.Demo.seed_failed(\"#{does_not_exist}\")")
  end

  def seed_failed(product_id) do
    MagasinData.Repo.insert!(%MagasinData.Inventory.StockItemRecord{
      id: Inventory.StockItemRepository.next_id().value,
      product_id: product_id,
      count_on_hand: 10
    })
  end
end
