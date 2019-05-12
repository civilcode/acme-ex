defmodule Magasin.Sales.OrderApplicationService do
  @moduledoc false

  use CivilCode.ApplicationService

  alias CivilCode.{RepositoryError, Validation}
  alias Magasin.Sales.{Order, OrderId, OrderRepository, PlaceOrder}

  @type result :: {:ok, OrderId.t()} | {:error, Validation.t() | RepositoryError.t()}
  @spec handle(PlaceOrder.t()) :: result
  def handle(%PlaceOrder{} = place_order) do
    with {:ok, params} <- PlaceOrder.to_domain(place_order),
         {:ok, order} <- Order.place(params) do
      OrderRepository.save(order)
    end
  end
end
