defmodule CivilCode.ResultMap do
  @moduledoc false

  def unwrap(map) do
    map
    |> Enum.map(&unwrap_result/1)
    |> Enum.into(%{})
  end

  defp unwrap_result({key, results_by_key_collection})
       when is_list(results_by_key_collection) do
    {key, Enum.map(results_by_key_collection, &unwrap_result/1)}
  end

  defp unwrap_result(results_by_key) when is_map(results_by_key) do
    for {key, result} <- results_by_key, into: %{}, do: {key, Result.unwrap(result)}
  end

  defp unwrap_result({key, result}) do
    {key, Result.unwrap(result)}
  end
end
