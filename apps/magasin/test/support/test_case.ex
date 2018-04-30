defmodule Magasin.TestCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Magasin.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Magasin.TestCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Magasin.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Magasin.Repo, {:shared, self()})
    end

    :ok
  end
end
