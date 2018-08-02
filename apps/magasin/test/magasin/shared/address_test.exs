defmodule Magasin.AddressTest do
  use Magasin.TestCase

  alias Magasin.{Address, PostalCode}

  describe "new" do
    test "missing params returns an error" do
      result = Address.new(nil)
      assert {:error, "is required"} == result
    end

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

      {:error, errors} = Address.new(invalid_params)

      assert {:street_address, "is required"} in errors
      assert {:postal_code, "is required"} in errors
    end
  end
end