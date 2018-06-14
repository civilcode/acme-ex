defmodule Magasin.Sales.Domain.Order do
  @moduledoc false

  use CivilCode.Aggregate

  alias Magasin.Sales.Domain.{Order, OrderPlaced}

  def place(state, guid, email) do
    order_placed = %OrderPlaced{guid: guid, email: email}
    new_state = Order.State.apply(state, order_placed)

    {:ok, %__MODULE__{state: new_state, events: [order_placed]}}
  end
end
