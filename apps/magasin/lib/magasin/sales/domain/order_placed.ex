defmodule Magasin.Sales.Domain.OrderPlaced do
  use CivilCode.DomainEvent

  defstruct [:guid, :email]
end
