defmodule Magasin.Inventory.Domain.OutOfStock do
  @moduledoc false

  use CivilCode.BusinessRuleViolation

  defstruct [:entity]
end
