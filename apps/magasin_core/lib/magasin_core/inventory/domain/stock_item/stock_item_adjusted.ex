defmodule MagasinCore.Inventory.StockItemAdjusted do
  @moduledoc """
  A domain event representing the fact when a stock item is adjusted.
  """

  use CivilCode.DomainEvent

  typedstruct enforce_keys: true do
    field :stock_item_id, MagasinData.Inventory.StockItemId.t()
    field :new_count_on_hand, MagasinData.Email.t()
  end
end
