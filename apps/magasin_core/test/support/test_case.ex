defmodule MagasinCore.TestCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      alias MagasinData.Repo

      import Ecto
      import Ecto.Changeset, except: [apply_changes: 1]
      import Ecto.Query
      import MagasinCore.TestCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MagasinData.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(MagasinData.Repo, {:shared, self()})
    end

    :ok
  end

  def build_entity(factory_name, attrs \\ []) do
    MagasinCore.Factory.build(factory_name, attrs)
  end

  def apply_changes({:ok, changeset}) do
    Ecto.Changeset.apply_changes(changeset)
  end

  @doc """
  A helper that transform changeset errors to a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", value_to_string(value))
      end)
    end)
  end

  defp value_to_string({:array, :map}), do: "array[map]"

  defp value_to_string(value), do: to_string(value)

  def sales_order_id_factory do
    MagasinCore.Sales.OrderRepository.next_id()
  end

  def catalog_product_id_factory do
    MagasinCore.Catalog.ProductRepository.next_id()
  end
end
