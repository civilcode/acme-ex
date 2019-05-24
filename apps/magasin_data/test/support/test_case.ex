defmodule MagasinData.TestCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      alias MagasinData.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import MagasinData.TestCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MagasinData.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(MagasinData.Repo, {:shared, self()})
    end

    :ok
  end

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", value_to_string(value))
      end)
    end)
  end

  defp value_to_string({:array, :map}), do: "array[map]"

  defp value_to_string(value), do: to_string(value)
end
