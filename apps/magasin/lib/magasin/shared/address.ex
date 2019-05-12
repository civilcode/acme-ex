defmodule Magasin.Address do
  @moduledoc false

  use CivilCode.DomainPrimitive.Composite
  alias Magasin.PostalCode

  embedded_schema do
    field(:street_address, :string)
    field(:city, :string)
    field(:postal_code, PostalCode.Ecto.Type)
  end

  @required [:street_address, :city, :postal_code]

  def validate(schema), do: validate_required(schema, @required)
end
