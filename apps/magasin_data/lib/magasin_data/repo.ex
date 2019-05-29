defmodule MagasinData.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :magasin_data, adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [lock: 2]

  def init(_type, config) do
    {:ok, Keyword.put(config, :url, System.get_env("DATABASE_URL"))}
  end

  def lock(query) do
    lock(query, "FOR UPDATE")
  end
end
