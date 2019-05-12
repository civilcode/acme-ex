defmodule Magasin.Catalog.ProductRepository do
  @moduledoc """
  This is not a complete implementation of a repository as we only need in this example
  application is the `product_id`.
  """

  alias Magasin.Catalog.ProductId

  def next_id do
    ProductId.new!(UUID.uuid4())
  end
end
