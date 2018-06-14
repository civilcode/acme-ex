defmodule Magasin.Sales.Application.OrderApplicationService do
  @moduledoc false

  use CivilCode.ApplicationService

  alias Magasin.Sales.Application.{OrderRepository, PlaceOrder}
  alias Magasin.Sales.Domain.Order

  def handle(%PlaceOrder{} = place_order) do
    with {:ok, valid_command} <- PlaceOrder.validate(place_order),
         {:ok, order} <- Order.place(%Order.State{}, valid_command.guid(), valid_command.email) do
      OrderRepository.add(order)
    end
  end
end
