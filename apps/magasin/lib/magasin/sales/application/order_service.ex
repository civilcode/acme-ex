defmodule Magasin.Sales.Application.OrderApplicationService do
  alias Magasin.Sales.Application.PlaceOrder
  alias Magasin.Sales.Domain.Order

  def handle(%PlaceOrder{} = place_order) do
    %Order{id: place_order.guid()}
    |> Order.place(place_order.email)
    |> Magasin.Repo.insert()
  end
end
