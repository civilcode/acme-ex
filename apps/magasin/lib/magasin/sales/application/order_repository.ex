defmodule Magasin.Sales.Application.OrderRepository do
  use CivilCode.Repository

  alias Magasin.Repo
  alias Magasin.Sales.Domain.Order

  def add(order) do
    Repo.insert(order.state)
  end

  def get(guid) do
    Repo.get(Order.State, guid)
  end
end
