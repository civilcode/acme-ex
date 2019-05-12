defmodule Magasin.Inventory.Domain.StockItemAdjusted do
  @moduledoc false

  use CivilCode.DomainEvent

  typedstruct enforce_keys: true do
    field :stock_item_id, Magasin.Inventory.Domain.StockItemId.t()
    field :new_count_on_hand, Magasin.Email.t()
  end
end
