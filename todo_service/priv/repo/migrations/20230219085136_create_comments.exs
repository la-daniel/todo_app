defmodule TodoApi.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :comment, :string
      add :task_id, references(:tasks, on_delete: :delete_all)

      timestamps()
    end

    create index(:comments, [:task_id])
  end
end
