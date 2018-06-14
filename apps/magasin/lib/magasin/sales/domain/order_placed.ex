defmodule Magasin.Sales.Domain.OrderPlaced do
  @moduledoc false

  use CivilCode.DomainEvent

  defstruct [:guid, :email]
end
