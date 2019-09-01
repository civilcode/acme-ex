defmodule MagasinCore.Inventory.StockItemId do
  @moduledoc """
  The ID of a stock item entity.
  """

  use CivilCode.ValueObject, type: :uuid
end
