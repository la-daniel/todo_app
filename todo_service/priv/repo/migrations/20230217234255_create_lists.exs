defmodule TodoApi.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :order, :integer
      add :title, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :assigned_to, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:lists, [:user_id])
    create index(:lists, [:assigned_to])
  end
end
