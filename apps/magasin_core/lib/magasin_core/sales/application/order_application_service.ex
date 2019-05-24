defmodule MagasinCore.Sales.OrderApplicationService do
  @moduledoc """
  The command handler for commands on an order aggregate.
  """

  use CivilCode.ApplicationService

  alias MagasinCore.Sales.{Order, OrderRepository, PlaceOrder}
  alias MagasinData.Sales.OrderId

  @type result ::
          {:ok, OrderId.t()} | {:error, Ecto.Changeset.t(PlaceOrder.t()) | RepositoryError.t()}
  @spec handle(PlaceOrder.t()) :: result
  def handle(%PlaceOrder{} = place_order) do
    OrderRepository.transaction(fn ->
      with {:ok, params} <- PlaceOrder.to_domain(place_order),
           {:ok, order} <- Order.place(params) do
        OrderRepository.save(order)
      end
    end)
  end
end
