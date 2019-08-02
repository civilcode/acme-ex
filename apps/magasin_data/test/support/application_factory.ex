defmodule MagasinData.ApplicationFactory do
  @moduledoc """
  The factory module for MagasinData, which can be included in other apps' factories.

  Rules for factory naming:
  - use the singular form of the subdomain (e.g. Accounts.Trade -> account_trade_factory)
  - if the subdomain duplicates the entity name, drop the subdomain
  (e.g. Clients.Client -> client_factory)
  """

  defmacro __using__(_opts) do
    quote do
      use MagasinData.SharedFactory
    end
  end
end
