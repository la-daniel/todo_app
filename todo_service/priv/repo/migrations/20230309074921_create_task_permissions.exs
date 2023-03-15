defmodule TodoApi.Repo.Migrations.CreateTaskPermissions do
  use Ecto.Migration

  def change do
    create table(:task_permissions) do
      add :read, :boolean, default: false, null: false
      add :write, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :task_id, references(:tasks, on_delete: :nothing)

      timestamps()
    end

    create index(:task_permissions, [:user_id])
    create index(:task_permissions, [:task_id])
  end
end
