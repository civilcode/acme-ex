defmodule Magasin.Sales.Domain.OrderPlaced do
  use CivilCode.DomainEvent

  defstruct [:guid, :email, :product_guid, :quantity]
end
