defmodule Explorer.Repo.Migrations.MakeGolemBaseEntitiesOwnerNullable do
  use Ecto.Migration

  def up do
    if Application.get_env(:explorer, :environment) == :test do
      alter table(:golem_base_entities) do
        modify(:owner, :binary, null: true)
      end
    end
  end

  def down do
    if Application.get_env(:explorer, :environment) == :test do
      alter table(:golem_base_entities) do
        modify(:owner, :binary, null: false)
      end
    end
  end
end
