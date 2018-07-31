defmodule Magasin.Address do
  @moduledoc false

  use CivilCode.DomainPrimitive

  alias Magasin.PostalCode

  defstruct [:street_address, :city, :postal_code]

  def new(nil), do: Result.error("is required")

  def new(params) do
    with validation_results = build_validation_results(params),
         {:ok, valid_params} <- build_valid_params(validation_results) do
      __MODULE__
      |> struct(valid_params)
      |> Result.ok()
    end
  end

  def new!(street_address, city, postal_code) do
    {:ok, address} = new(street_address: street_address, city: city, postal_code: postal_code)
    address
  end

  defp build_validation_results(params) do
    [
      street_address: validate_presence(params[:street_address]),
      city: validate_presence(params[:city]),
      postal_code: PostalCode.new(params[:postal_code])
    ]
  end

  defp validate_presence(nil), do: Result.error("is required")
  defp validate_presence(value), do: Result.ok(value)

  defp build_valid_params(results) do
    Enum.reduce(results, {:ok, %{}}, &handle_validation_result/2)
  end

  defp handle_validation_result({field_name, validation_result}, valid_params) do
    case validation_result do
      {:ok, valid_param} -> merge_valid_param(field_name, valid_param, valid_params)
      {:error, error} -> merge_error(field_name, error, valid_params)
    end
  end

  defp merge_valid_param(field_name, valid_param, valid_params) do
    case valid_params do
      {:error, _} -> valid_params
      {:ok, valid_params} -> valid_params |> Map.put(field_name, valid_param) |> Result.ok()
    end
  end

  defp merge_error(field_name, error, valid_params) do
    case valid_params do
      {:error, errors} -> Result.error([{field_name, error} | errors])
      _valid_params -> Result.error([{field_name, error}])
    end
  end
end
