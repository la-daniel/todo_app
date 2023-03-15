defmodule TodoApi.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :detail, :string
    field :order, :integer
    field :title, :string
    field :list_id, :id
    field :assigned_to, :id
    field :user_id, :id
    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:detail, :title, :order, :user_id, :id])
    |> validate_required([:detail, :title, :order, :user_id, :id])
  end
end
