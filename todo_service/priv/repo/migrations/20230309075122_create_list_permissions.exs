defmodule TodoApi.Repo.Migrations.CreateListPermissions do
  use Ecto.Migration

  def change do
    create table(:list_permissions) do
      add :read, :boolean, default: false, null: false
      add :write, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :list_id, references(:lists, on_delete: :nothing)

      timestamps()
    end

    create index(:list_permissions, [:user_id])
    create index(:list_permissions, [:list_id])
  end
end
