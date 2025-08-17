defmodule Explorer.Chain.GolemBase do
  @moduledoc """
  Golem Base root namespace module.
  """

  @doc """
  Helper function to determine if Golem Base support is enabled.
  """
  def enabled? do
    Application.get_env(:explorer, __MODULE__)[:enabled]
  end
end
