defmodule CivilCode.Command do
  @moduledoc false

  alias CivilCode.ValidationError

  defmacro __using__(args) do
    quote do
      alias CivilCode.Command

      @schema unquote(args[:schema])

      def to_domain(command), do: Command.to_domain(@schema, command)
    end
  end

  # Converts the command to a map of domain primitives or a ValidationError
  def to_domain(schema, command) do
    values = get_domain_primitive_results_by_key(schema, command)

    errors =
      values
      |> filter_errors
      |> unwrap_results

    if Enum.any?(errors) do
      Result.error(%ValidationError{data: command, errors: errors})
    else
      values
      |> unwrap_results
      |> Enum.into(%{})
      |> Result.ok()
    end
  end

  defp get_domain_primitive_results_by_key(schema, command) do
    Enum.map(schema, fn {key, module} ->
      {key, module.new(Map.get(command, key))}
    end)
  end

  defp unwrap_results(domain_primitive_results_by_key) do
    Enum.map(domain_primitive_results_by_key, fn {key, {_status, msg}} -> {key, msg} end)
  end

  defp filter_errors(domain_primitive_results_by_key) do
    Enum.filter(domain_primitive_results_by_key, fn {_key, {status, _}} ->
      status == :error
    end)
  end
end
