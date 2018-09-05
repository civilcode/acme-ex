defmodule CivilCode.DomainPrimitive do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      @type t :: %__MODULE__{}

      @behaviour Elixir.Ecto.Type

      def cast(value) do
        case new(value) do
          {:ok, _} = result -> result
          {:error, _} -> :error
        end
      end

      def type, do: :no_implemented
      def load(_), do: :no_implemented
      def dump(_), do: :no_implemented
    end
  end
end
