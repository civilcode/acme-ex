defmodule MagasinData.Quantity do
  @moduledoc false

  use CivilCode.ValueObject, type: :non_neg_integer

  @spec subtract(t, t) :: {:ok, t} | {:error, atom}
  def subtract(a, b) do
    new(a.value - b.value)
  end
end
