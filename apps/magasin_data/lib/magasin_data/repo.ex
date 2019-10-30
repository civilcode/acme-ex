defmodule MagasinData.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :magasin_data, adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [lock: 2]

  def lock(query) do
    lock(query, "FOR UPDATE")
  end
end
