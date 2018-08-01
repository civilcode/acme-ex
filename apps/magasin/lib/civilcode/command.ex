defmodule CivilCode.Command do
  @moduledoc false

  alias CivilCode.{ResultMap, Schema, Validation}

  defmacro __using__(args) do
    quote do
      alias CivilCode.Command

      @schema unquote(args[:schema])

      def to_domain(command), do: Command.to_domain(@schema, command)
    end
  end

  # Converts the command to a map of domain primitives or a ValidationError
  def to_domain(schema, command) do
    domain_primitive_results = Schema.to_domain(schema, command)
    validation = Validation.new(domain_primitive_results, command)

    if Validation.errors?(validation) do
      Result.error(validation)
    else
      domain_primitive_results
      |> ResultMap.unwrap()
      |> Result.ok()
    end
  end
end
