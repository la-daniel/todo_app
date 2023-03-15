defmodule TodoApi.Todo.TaskPermission do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:task_id, :user_id]}
  schema "task_permissions" do
    field :read, :boolean, default: false
    field :write, :boolean, default: false
    field :user_id, :id
    field :task_id, :id

    timestamps()
  end

  @doc false
  def changeset(task_permission, attrs) do
    task_permission
    |> cast(attrs, [:read, :write])
    |> validate_required([:read, :write])
  end
end
