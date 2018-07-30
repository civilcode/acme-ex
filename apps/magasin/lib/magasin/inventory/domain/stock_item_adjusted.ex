defmodule Magasin.Inventory.Domain.StockItemAdjusted do
  @moduledoc false

  use CivilCode.DomainEvent

  @enforce_keys [:stock_item_id, :new_count_on_hand]
  defstruct [:stock_item_id, :new_count_on_hand]

  @type t :: %__MODULE__{
          stock_item_id: Magasin.Inventory.Domain.StockItemId.t(),
          new_count_on_hand: Magasin.Email.t()
        }
end
