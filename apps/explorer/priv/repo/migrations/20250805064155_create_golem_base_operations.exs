defmodule Explorer.Repo.Migrations.CreateGolemBaseOperations do
  use Ecto.Migration

  def up do
    # Create golem_base_operation_type enum type if it doesn't exist
    execute("""
    DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'golem_base_operation_type') THEN
            CREATE TYPE golem_base_operation_type AS ENUM ('create', 'update', 'delete', 'extend');
        END IF;
    END$$;
    """)

    create table(:golem_base_operations, primary_key: false) do
      add(:entity_key, :binary, null: false)
      add(:sender, :binary, null: false)
      add(:recipient, :binary, null: false)
      add(:operation, :golem_base_operation_type, null: false)
      add(:data, :binary)
      add(:btl, :decimal, precision: 21, scale: 0)

      add(:block_hash, :binary, null: false)
      add(:transaction_hash, :binary, null: false)
      add(:index, :bigint, null: false)

      add(:inserted_at, :naive_datetime, null: false, default: fragment("now()"))
    end

    # Add composite primary key
    execute("ALTER TABLE golem_base_operations ADD PRIMARY KEY (transaction_hash, index)")

    # Add check constraints
    execute("""
    ALTER TABLE golem_base_operations 
    ADD CONSTRAINT golem_base_operations_create_update_check 
    CHECK (operation NOT IN ('create', 'update') OR (data IS NOT NULL AND btl IS NOT NULL))
    """)

    execute("""
    ALTER TABLE golem_base_operations 
    ADD CONSTRAINT golem_base_operations_delete_check 
    CHECK (operation != 'delete' OR (data IS NULL AND btl IS NULL))
    """)

    execute("""
    ALTER TABLE golem_base_operations 
    ADD CONSTRAINT golem_base_operations_extend_check 
    CHECK (operation != 'extend' OR (data IS NULL AND btl IS NOT NULL))
    """)

    # Create indexes
    create(index(:golem_base_operations, [:entity_key]))
    create(index(:golem_base_operations, [:sender]))
    create(index(:golem_base_operations, [:transaction_hash]))
    create(index(:golem_base_operations, [:block_hash]))
  end

  def down do
    drop(table(:golem_base_operations))

    # Drop golem_base_operation_type enum if it exists
    execute("""
    DO $$
    BEGIN
      DROP TYPE IF EXISTS golem_base_operation_type;
    END$$
    """)
  end
end
