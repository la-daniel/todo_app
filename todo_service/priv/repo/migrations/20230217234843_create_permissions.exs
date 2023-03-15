defmodule TodoApi.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :user_id, references(:users, on_delete: :nothing)
      add :task_id, references(:tasks, on_delete: :nothing)

      timestamps()
    end

    create index(:permissions, [:user_id])
    create index(:permissions, [:task_id])
  end
end
