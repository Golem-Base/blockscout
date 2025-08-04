defmodule Explorer.Chain.GolemBase.Operation do
  @moduledoc """
  The representation of a Golem Base operation
  """

  use Explorer.Schema
  alias Explorer.Chain.Hash

  @primary_key false
  typed_schema "golem_base_operations" do
    field(:entity_key, Hash.Full, primary_key: true, null: false)
    field(:sender, Hash.Address, null: false)
  end

  def changeset(%__MODULE__{} = golembase_operation, attrs) do
    golembase_operation
    |> cast(attrs, [:entity_key, :sender])
    |> validate_required([:entity_key, :sender])
  end

  def enabled? do
    Application.get_env(:explorer, __MODULE__)[:enabled]
  end
end
