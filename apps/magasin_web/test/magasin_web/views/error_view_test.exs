defmodule MagasinWeb.ErrorViewTest do
  use MagasinWeb.ConnCase, async: true

  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(MagasinWeb.ErrorView, "404.html", []) =~ "(404)"
  end

  test "renders 500.html" do
    assert render_to_string(MagasinWeb.ErrorView, "500.html", []) =~ "(500)"
  end
end
