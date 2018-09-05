defmodule Magasin.PostalCode do
  @moduledoc false

  use CivilCode.DomainPrimitive

  defstruct [:value]

  def new(":invalid:"), do: Result.error(:invalid)

  def new(value) do
    {:ok, struct(__MODULE__, value: value)}
  end

  def new!(value) do
    {:ok, postal_code} = new(value)
    postal_code
  end
end
