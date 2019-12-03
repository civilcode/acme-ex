defmodule MagasinData.ReleaseTasks do
  @moduledoc false

  # Based on the Distillery Guide [1]. Some modifications have been made to deal with exceptions
  # and running mix tasks from the seeding script. The differences have been noted inline
  # below as a `CHANGE`.
  #
  # [1] https://hexdocs.pm/distillery/running-migrations.html

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  # CHANGE: Hardcode the application name rather than use `Application.get_application(__MODULE__)`
  # otherwise we get the following error:
  #
  # {"init terminating in do_boot",{{badmatch,{error,{"no such file or directory","nil.app"}}},
  # [{'Elixir.Gccg.ReleaseTasks',seed,0,[{file,"lib/release_tasks.ex"},{line,18}]},
  # {init,start_em,1,[]}, {init,do_boot,3,[]}]}} init terminating in do_boot
  # ({{badmatch,{error,{[_],[_]}}},[{Elixir.Gccg.ReleaseTasks,seed,0,[{_},{_}]},
  # {init,start_em,1,[]},{init,do_boot,3,[]}]})

  def myapp, do: :magasin_data

  def repos, do: Application.get_env(myapp(), :ecto_repos, [])

  @doc """
  Run database migrations.
  """
  def db_migrate do
    me = myapp()

    # CHANGE: Start the entire application rather than just loading the code and manually
    # start the application's `Repo`s. Why: the mix task called in the seeding script contains
    # a `Application.ensure_all_started/1` which will fail as they `Repo`s are already
    # started, i.e.;
    #     {failed_to_start_child,'Elixir.MyApp.Repo', pid}
    IO.puts("Starting #{me}..")
    {:ok, _} = Application.ensure_all_started(me)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Init EventStore
    event_store()

    # Run migrations
    migrate()

    # Run seed script
    Enum.each(repos(), &run_seeds_for/1)

    # Signal shutdown
    IO.puts("Success!")
    :init.stop()
  end

  defp event_store do
    config = EventStore.Config.parsed(CivilBus.EventStore.Repo, :civil_bus)
    :ok = EventStore.Tasks.Init.exec(CivilBus.EventStore.Repo, config, [])
  end

  defp migrate, do: Enum.each(repos(), &run_migrations_for/1)

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    IO.puts("Running migrations for #{app}")
    IO.puts("Running migrations against #{repo}")
    IO.puts("Running migrations from #{migrations_path(repo)}")

    Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
  end

  def migrations_path(repo), do: priv_path_for(repo, "migrations")

  def priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)
    repo_underscore = repo |> Module.split() |> List.last() |> Macro.underscore()
    Path.join([priv_dir(app), repo_underscore, filename])
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  @doc """
  Seed the database required by the application(s).
  """
  def db_seed do
    me = myapp()

    # CHANGE: Start the entire application rather than just loading the code and manually
    # start the application's `Repo`s. Why: the mix task called in the seeding script contains
    # a `Application.ensure_all_started/1` which will fail as they `Repo`s are already
    # started, i.e.;
    #     {failed_to_start_child,'Elixir.MyApp.Repo', pid}
    IO.puts("Starting #{me}..")
    {:ok, _} = Application.ensure_all_started(me)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Run seed script
    Enum.each(repos(), &run_seeds_for/1)

    # Signal shutdown
    IO.puts("Success!")
    :init.stop()
  end

  defp run_seeds_for(repo) do
    # Run the seed script if it exists
    seed_script = seeds_path(repo)

    if File.exists?(seed_script) do
      IO.puts("Running seed script..")
      Code.eval_file(seed_script)
    end
  end

  defp seeds_path(repo), do: priv_path_for(repo, "seeds.exs")

  @doc """
  Loads seed data + fake data dumped from dev database. (For use on staging servers)
  """
  def demo_load do
    database_url = System.get_env("DATABASE_URL")

    base_command = "psql"
    pipe_location = "< /app/lib/magasin_demo-0.0.0/priv/demo.sql"

    command =
      [base_command, database_url, pipe_location]
      |> Enum.join(" ")
      |> String.to_charlist()

    :os.cmd(command)
  end
end
