defmodule CivilCode.Command do
  @moduledoc false

  defmacro __using__(_args) do
    quote do
      @type t :: %__MODULE__{}
    end
  end
end
