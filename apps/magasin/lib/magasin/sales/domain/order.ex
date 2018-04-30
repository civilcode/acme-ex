defmodule Magasin.Sales.Domain.Order do
  # Discussion: State?

  use Magasin.Schema

  schema "magasin_sale_orders" do
    field(:email, :string)

    timestamps()
  end

  def place(state, email) do
    %{state | email: email}
  end
end
