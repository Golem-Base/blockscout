defmodule Explorer.Chain.Cache.GolemBase do
  @moduledoc """
  MapCache module for Golem Base support.
  """

  use Explorer.Chain.MapCache, name: :golembase, key: :number_of_used_slots

  defp handle_fallback(:number_of_used_slots) do
    json_rpc_named_arguments = Application.get_env(:explorer, :json_rpc_named_arguments)

    case EthereumJSONRPC.fetch_golembase_number_of_used_slots(json_rpc_named_arguments) do
      {:ok, count} ->
        {:update, count}

      {:error, reason} ->
        {:return, nil}
    end
  end

  defp handle_fallback(_key), do: {:return, nil}
end
