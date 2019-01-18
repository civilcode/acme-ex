defmodule MagasinWeb.LayoutView do
  @moduledoc false

  use MagasinWeb, :view

  def release_tag do
    :magasin
    |> Application.get_env(:release)
    |> Keyword.get(:tag)
  end
end
