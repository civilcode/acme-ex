defmodule Magasin.Sales.Application.OrderApplicationService do
  @moduledoc false

  use CivilCode.ApplicationService

  alias Magasin.Sales.Application.{OrderRepository, PlaceOrder}
  alias Magasin.Sales.Domain.Order

  def handle(%PlaceOrder{} = place_order) do
    with {:ok, params} <- PlaceOrder.to_domain(place_order),
         {:ok, order} <- Order.place(params) do
      OrderRepository.add(order)
    end
  end
end
