defmodule Mix.Tasks.Demo.Dump do
  @moduledoc "Mix task to dump the dev database to demo.sql -- used locally."

  use Mix.Task

  @shortdoc "Task to dump the dev database"

  def run(_) do
    # Read the database config
    db_config = Application.get_env(:magasin_data, MagasinData.Repo)
    database = db_config[:database]
    hostname = db_config[:hostname]
    user = db_config[:username]
    password = db_config[:password]

    base_command = "pg_dump --inserts --exclude-table-data system_imports --clean"
    user_option = "-U #{user}"
    password_option = build_password_option(password)
    hostname_option = "-h #{hostname}"
    pipe_location = "> /app/apps/magasin_data/priv/demo.sql"

    command =
      [base_command, user_option, password_option, hostname_option, database, pipe_location]
      |> Enum.join(" ")
      |> String.to_charlist()

    :os.cmd(command)
  end

  defp build_password_option(nil), do: ""
  defp build_password_option(password), do: "-W #{password}"
end
