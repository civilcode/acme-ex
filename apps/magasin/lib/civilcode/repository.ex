defmodule CivilCode.Repository do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      alias CivilCode.Entity

      def build(module, func) do
        state = func.()
        Entity.build(module, state)
      end
    end
  end
end
