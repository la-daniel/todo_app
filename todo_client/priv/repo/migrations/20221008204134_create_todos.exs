defmodule TodoApi.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string
      add :detail, :string
      add :order, :integer, null: true

      timestamps()
    end
  end
end
