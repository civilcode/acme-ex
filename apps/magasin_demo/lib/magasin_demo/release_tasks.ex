defmodule MagasinDemo.ReleaseTasks do
  @moduledoc false

  # Loads seed data + fake data dumped from dev database.
  # (For use on staging servers)
  def load_demo_data do
    database_url = System.get_env("DATABASE_URL")

    base_command = "psql"
    pipe_location = "< /app/lib/magasin_demo-0.0.0/priv/demo_dump.sql"

    command =
      [base_command, database_url, pipe_location]
      |> Enum.join(" ")
      |> String.to_charlist()

    :os.cmd(command)
  end
end
