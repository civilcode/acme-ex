defmodule CivilCode.DomainPrimitive do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      @type t :: %__MODULE__{}
    end
  end
end
