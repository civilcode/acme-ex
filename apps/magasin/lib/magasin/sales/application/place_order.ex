defmodule Magasin.Sales.Application.PlaceOrder do
  use CivilCode.Command

  defstruct [:guid, :email]
end
