defmodule CivilCode.Repository do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      alias CivilCode.Entity

      def build(module, func) do
        record = func.()

        module
        |> Entity.build(record)
        |> Entity.put_assigns(:record, record)
      end
    end
  end
end
