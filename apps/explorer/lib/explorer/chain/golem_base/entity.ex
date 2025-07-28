defmodule Explorer.Chain.GolemBase.Entity do
  @moduledoc """
  The representation of a Golem Base entity
  """

  import Ecto.Query, only: [where: 2]

  use Explorer.Schema
  alias Explorer.Chain
  alias Explorer.Chain.Hash

  @type api? :: {:api?, true | false}

  @primary_key false
  typed_schema "golem_base_entities" do
    field(:key, Hash.Full, primary_key: true, null: false)
    field(:status, Ecto.Enum, values: [:active, :deleted, :expired])
    field(:owner, :binary, null: false)
    field(:last_updated_at_tx_hash, :binary, null: false)
    field(:expires_at_block_number, :integer, null: false)

    timestamps()
  end

  def changeset(%__MODULE__{} = golembase_entity, attrs) do
    golembase_entity
    |> cast(attrs, [:key, :status, :owner, :last_updated_at_tx_hash, :expires_at_block_number])
    |> validate_required([:key, :status, :owner, :last_updated_at_tx_hash, :expires_at_block_number])
  end

  @spec hash_to_golembase_entity(Hash.Full.t(), [api?]) ::
          {:ok, __MODULE__.t()} | {:error, :not_found}
  def hash_to_golembase_entity(%Hash{byte_count: unquote(Hash.Full.byte_count())} = hash, options \\ [])
      when is_list(options) do
    __MODULE__
    |> where(key: ^hash)
    |> where(status: :active)
    |> Chain.select_repo(options).one()
    |> case do
      nil ->
        {:error, :not_found}

      golembase_entity ->
        {:ok, golembase_entity}
    end
  end

  def enabled? do
    Application.get_env(:explorer, __MODULE__)[:enabled]
  end
end
