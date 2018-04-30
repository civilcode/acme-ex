defmodule Magasin.Sales.Application.PlaceOrder do
  use CivilCode.Command

  defstruct [:guid, :email]

  def validate(command) do
    if is_nil(command.email) do
      {:error, "invalid"}
    else
      {:ok, command}
    end
  end
end
