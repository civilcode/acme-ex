defmodule MagasinCore.AddressTest do
  use MagasinCore.TestCase

  alias MagasinCore.{Address, PostalCode}

  describe "new" do
    test "valid params returns a new address" do
      valid_params = %{
        street_address: "1 Main St",
        city: "Montreal",
        postal_code: "H2T1S6"
      }

      expected_address = %Address{
        street_address: "1 Main St",
        city: "Montreal",
        postal_code: PostalCode.new!("H2T1S6")
      }

      assert {:ok, expected_address} == Address.new(valid_params)
    end

    test "invalid params returns validation errors" do
      invalid_params = %{
        street_address: nil,
        city: "Montreal",
        postal_code: nil
      }

      {:error, invalid_changeset} = Address.new(invalid_params)

      refute invalid_changeset.valid?
      assert "can't be blank" in errors_on(invalid_changeset).street_address
      assert "can't be blank" in errors_on(invalid_changeset).postal_code
    end
  end
end
