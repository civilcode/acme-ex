defmodule CivilCode.Schema do
  @moduledoc false

  def to_domain(schema, params) do
    for {key, module} <- schema,
        into: %{},
        do: {key, build_new_domain_primitive({key, module}, params)}
  end

  defp build_new_domain_primitive({key, module}, params) do
    build_new_domain_primitive(module, Map.get(params, key))
  end

  defp build_new_domain_primitive([_embedded_schema], nil = _params), do: []

  defp build_new_domain_primitive([embedded_schema], params_collection)
       when is_list(params_collection) do
    Enum.map(params_collection, &to_domain(embedded_schema, &1))
  end

  defp build_new_domain_primitive(module, params) do
    module.new(params)
  end
end
