defmodule Result do
  @moduledoc false

  def ok(value), do: {:ok, value}
  def error(value), do: {:error, value}
  def unwrap({_, value}), do: value
end
