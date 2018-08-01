defmodule CivilCode.Validation do
  @moduledoc false

  defstruct [:data, :errors]

  alias CivilCode.ResultMap

  def new(domain_primitive_results_by_key, data) do
    errors =
      domain_primitive_results_by_key
      |> Enum.filter(&error?/1)
      |> ResultMap.unwrap()

    struct(__MODULE__, data: data, errors: errors)
  end

  defp error?({_key, {:error, _domain_primitive}}), do: true
  defp error?(_term), do: false

  def errors?(validation), do: Enum.any?(validation.errors)
end
