defmodule MagasinCore.Address do
  @moduledoc false

  use CivilCode.ValueObject, type: :composite, required: [:street_address, :city, :postal_code]

  alias MagasinCore.PostalCode

  embedded_schema do
    field :street_address, :string
    field :city, :string
    field :postal_code, PostalCode
  end
end
