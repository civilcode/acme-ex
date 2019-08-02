defmodule MagasinData.SharedFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias MagasinData.{Email, Quantity}

      def quantity_factory do
        Quantity.new!(Enum.random(1..1000))
      end

      def email_factory do
        Email.new!(Faker.Internet.email())
      end
    end
  end
end
