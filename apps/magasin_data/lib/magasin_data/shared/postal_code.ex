defmodule MagasinData.PostalCode do
  @moduledoc false

  use CivilCode.ValueObject, type: :string

  def new(":invalid:"), do: {:error, :invalid}

  def new(value) do
    {:ok, struct(__MODULE__, value: value)}
  end
end
