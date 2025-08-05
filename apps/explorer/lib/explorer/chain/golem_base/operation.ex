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
    field(:recipient, Hash.Address, null: false)
    field(:operation, Ecto.Enum, values: [:create, :update, :delete, :extend], null: false)
    field(:data, :binary)
    field(:btl, :integer)
    field(:block_hash, Hash.Full, null: false)
    field(:transaction_hash, Hash.Full, null: false)
    field(:index, :integer, null: false)
  end

  def changeset(%__MODULE__{} = golembase_operation, attrs) do
    golembase_operation
    |> cast(attrs, [:entity_key, :sender, :recipient, :operation, :block_hash, :transaction_hash, :index, :data, :btl])
    |> validate_required([:entity_key, :sender, :recipient, :operation, :block_hash, :transaction_hash, :index])
  end

  def enabled? do
    Application.get_env(:explorer, __MODULE__)[:enabled]
  end
end
