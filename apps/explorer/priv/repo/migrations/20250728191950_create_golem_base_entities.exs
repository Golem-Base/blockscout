defmodule Explorer.Repo.Migrations.CreateGolemBaseEntities do
  use Ecto.Migration

  def change do
    create table(:golem_base_entities, primary_key: false) do
      add(:key, :bytea, null: false, primary_key: true)
    end
  end
end
