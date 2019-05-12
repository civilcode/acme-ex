defmodule Magasin.Inventory.OutOfStock do
  @moduledoc false

  use CivilCode.BusinessRuleViolation

  defstruct [:entity]
end
