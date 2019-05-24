defmodule MagasinData.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :magasin_data, adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    {:ok, Keyword.put(config, :url, System.get_env("DATABASE_URL"))}
  end
end
