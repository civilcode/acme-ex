{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start(timeout: 500)

Ecto.Adapters.SQL.Sandbox.mode(Magasin.Repo, :manual)
