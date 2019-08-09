defmodule MagasinCore.Catalog.ProductRepository do
  @moduledoc """
  This is not a complete implementation of a repository as we only need in this example
  application is the `product_id`.
  """

  alias MagasinData.Catalog.ProductId

  @spec next_id() :: ProductId.t()
  def next_id do
    ProductId.new!(UUID.uuid4())
  end
end
