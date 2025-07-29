defmodule Explorer.Repo.Migrations.CreateGolemBaseEntities do
  use Ecto.Migration

  @env Mix.env

  def up do
    if @env == :test do
      # Create golem_base_entity_status_type enum type if it doesn't exist
      execute("""
      DO $$
      BEGIN
          IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'golem_base_entity_status_type') THEN
              CREATE TYPE golem_base_entity_status_type AS ENUM ('active', 'deleted', 'expired');
          END IF;
      END$$;
      """)

      create table(:golem_base_entities, primary_key: false) do
        add(:key, :binary, null: false, primary_key: true)
        add(:data, :binary)
        add(:status, :golem_base_entity_status_type, null: false)
        add(:owner, :binary, null: false)

        add(:created_at_tx_hash, :binary)
        add(:last_updated_at_tx_hash, :binary, null: false)
        add(:expires_at_block_number, :bigint, null: false)

        add(:inserted_at, :naive_datetime, null: false, default: fragment("now()"))
        add(:updated_at, :naive_datetime, null: false, default: fragment("now()"))
      end
    end
  end

  def down do
    if @env == :test do
      drop(table(:golem_base_entities))

      # Drop golem_base_entity_status_type enum if it exists
      execute("""
      DO $$
      BEGIN
        DROP TYPE IF EXISTS golem_base_entity_status_type;
      END$$
      """)
    end
  end
end
