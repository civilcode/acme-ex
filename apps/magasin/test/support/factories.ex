defmodule Magasin.Factory do
  @moduledoc false

  use ExMachina

  alias Magasin.{Email, Quantity}

  alias Magasin.Sales.Domain, as: Sales

  def quantity_factory do
    Quantity.new!(Enum.random(1..1000))
  end

  def email_factory do
    Email.new!(Faker.Internet.email())
  end

  def sales_order_id_factory do
    Magasin.Sales.Application.OrderRepository.next_id()
  end

  def catalog_product_id_factory do
    Magasin.Catalog.Application.ProductRepository.next_id()
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
