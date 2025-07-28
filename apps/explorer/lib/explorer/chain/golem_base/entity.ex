defmodule Explorer.Chain.GolemBase.Entity do
  @moduledoc """
  The representation of a Golem Base entity
  """

  import Ecto.Query

  use Explorer.Schema
  alias Explorer.Chain.Hash

  @type api? :: {:api?, true | false}

  @primary_key false
  typed_schema "golem_base_entities" do
    field(:key, Hash.Full, primary_key: true, null: false)

    timestamps()
  end

  def changeset(%__MODULE__{} = golembase_entity, attrs) do
    golembase_entity
    |> cast(attrs, [:key])
    |> validate_required([:key])
  end

  def enabled? do
    Application.get_env(:explorer, __MODULE__)[:enabled]
  end
end
