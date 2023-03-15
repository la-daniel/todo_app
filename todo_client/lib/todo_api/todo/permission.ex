defmodule TodoApi.Todo.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field :user_id, :id
    field :task_id, :id

    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [])
    |> validate_required([])
  end
end
