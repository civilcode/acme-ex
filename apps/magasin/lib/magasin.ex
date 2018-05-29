defmodule Magasin do
  @moduledoc """
  Documentation for Magasin.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Magasin.hello
      :world

  """
  def hello do
    :world
  end

  def db_url do
    Application.get_env(:magasin, Magasin.Repo)[:url]
    System.get_env("DATABASE_URL")
  end
end
