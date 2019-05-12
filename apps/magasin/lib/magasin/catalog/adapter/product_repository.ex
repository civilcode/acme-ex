defmodule Magasin.Catalog.Application.ProductRepository do
  @moduledoc """
  This is not a complete implementation of a repository as all we need for this example
  application is the `product_id`.
  """

  alias Magasin.Catalog.Domain.ProductId

  def next_id do
    ProductId.new!(UUID.uuid4())
  end
end
