defmodule CivilCode.Aggregate do
  defmacro __using__(_) do
    quote do
      defstruct [:state, :events]
      import Kernel, except: [apply: 2]
    end
  end
end
