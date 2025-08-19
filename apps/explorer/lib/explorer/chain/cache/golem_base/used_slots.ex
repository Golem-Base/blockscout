defmodule Explorer.Chain.Cache.GolemBase.UsedSlots do
  @moduledoc """
  Caches Golem Base used slots as returned by `golembase_getNumberOfUsedSlots` JSON-RPC call.
  """

  require Logger

  use Explorer.Chain.MapCache,
    name: :golembase,
    key: :used_slots,
    ttl_check_interval: :timer.seconds(1),
    global_ttl: Application.get_env(:explorer, Explorer.Chain.GolemBase)[:cache_ttl_used_slots]

  defp handle_fallback(:used_slots) do
    json_rpc_named_arguments = Application.get_env(:explorer, :json_rpc_named_arguments)

    case EthereumJSONRPC.fetch_golembase_number_of_used_slots(json_rpc_named_arguments) do
      {:ok, count} ->
        {:update, count}

      {:error, reason} ->
        Logger.debug("Could not fetch golembase_getNumberOfUsedSlots: #{inspect(reason)}")
        {:return, nil}
    end
  end

  defp handle_fallback(_key), do: {:return, nil}
end
