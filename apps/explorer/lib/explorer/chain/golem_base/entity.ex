defmodule Explorer.Chain.GolemBase.Entity do
  @moduledoc """
  The representation of a Golem Base entity.
  """

  import Ecto.Query, only: [where: 2, from: 2]

  use Explorer.Schema
  alias Explorer.{Chain, Chain.Hash, Repo}

  @type api? :: {:api?, true | false}

  @primary_key false
  typed_schema "golem_base_entities" do
    field(:key, Hash.Full, primary_key: true, null: false)
    field(:data, :binary)
    field(:status, Ecto.Enum, values: [:active, :deleted, :expired])
    field(:owner, :binary, null: false)
    field(:last_updated_at_tx_hash, :binary, null: false)
    field(:expires_at_block_number, :integer, null: false)

    timestamps()
  end

  @doc """
  Creates a changeset for a Golem Base entity.

  Validates that required fields are present and casts the provided attributes.
  """
  def changeset(%__MODULE__{} = golembase_entity, attrs) do
    golembase_entity
    |> cast(attrs, [:key, :status, :owner, :last_updated_at_tx_hash, :expires_at_block_number, :data])
    |> validate_required([:key, :status, :owner, :last_updated_at_tx_hash, :expires_at_block_number])
  end

  @doc """
  Retrieves an active Golem Base entity by its hash key.

  Only returns entities with `:active` status.
  """
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

  @doc """
  Calculates the total size in bytes of all active entity data.

  Sums the length of the `data` field for all entities with `:active` status.
  """
  def active_entities_bytes do
    query =
      from(entity in __MODULE__,
        select: fragment("SUM(LENGTH(?))", entity.data)
      )

    Repo.one(query)
  end

  @doc """
  Returns the count of active entities.

  Counts all entities with `:active` status.
  """
  def active_entities_count do
    query = from(entity in __MODULE__, where: entity.status == :active, select: count())

    Repo.one(query)
  end
end
