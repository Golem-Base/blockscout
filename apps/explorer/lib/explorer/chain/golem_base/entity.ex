defmodule Explorer.Chain.GolemBase.Entity do
  @moduledoc """
  The representation of a Golem Base entity
  """

  import Ecto.Query

  use Explorer.Schema
  alias Explorer.Chain.Hash

  @primary_key false
  typed_schema "golem_base_entities" do
    field(:key, Hash.Full, primary_key: true, null: false)
    field(:status, Ecto.Enum, values: [:active, :deleted, :expired])
    field(:owner, :binary, null: false)

    timestamps()
  end

  def changeset(%__MODULE__{} = golembase_entity, attrs) do
    golembase_entity
    |> cast(attrs, [:key, :status, :owner])
    |> validate_required([:key, :status, :owner])
  end

  def enabled? do
    Application.get_env(:explorer, __MODULE__)[:enabled]
  end
end
