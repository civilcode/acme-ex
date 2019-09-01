defmodule MagasinCore.Sales.OrderApplicationService do
  @moduledoc """
  The command handler for commands on an order aggregate.
  """

  use CivilCode.ApplicationService

  alias MagasinCore.Sales.{Order, OrderId, OrderRepository, PlaceOrder}

  @spec handle(PlaceOrder.t()) ::
          {:ok, OrderId.t()} | {:error, Changeset.t(PlaceOrder.t()) | RepositoryError.t()}
  def handle(%PlaceOrder{} = command) do
    OrderRepository.transaction(fn ->
      with {:ok, changeset} <- place_order(command), do: OrderRepository.save(changeset)
    end)
  end

  defp place_order(command) do
    Order.place(command.order_id, command.email, command.product_id, command.quantity)
  end
end
