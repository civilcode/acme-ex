defmodule MagasinData.OrderState do
  @moduledoc """
  The state of the `MagasinData.OrderRecord`. This is not currently being used, but provides an
  example of how to use an enum `CivilCode.ValueObject`.
  """

  use CivilCode.ValueObject, type: :enum, values: [:pending, :paid, :shipped]
end
