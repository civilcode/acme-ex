defmodule Magasin.Sales.Application.OrderApplicationService do
  @moduledoc false

  use CivilCode.ApplicationService

  alias CivilCode.{RepositoryError, Validation}
  alias Magasin.Sales.Application.{OrderRepository, PlaceOrder}
  alias Magasin.Sales.Domain.{Order, OrderId}

  @type result :: {:ok, OrderId.t()} | {:error, Validation.t() | RepositoryError.t()}
  @spec handle(PlacerOrder.t()) :: result
  def handle(%PlaceOrder{} = place_order) do
    with {:ok, params} <- PlaceOrder.to_domain(place_order),
         {:ok, order} <- Order.place(params) do
      OrderRepository.add(order)
    end
  end
end
