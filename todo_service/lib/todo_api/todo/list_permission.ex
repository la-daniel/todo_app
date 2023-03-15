defmodule TodoApi.Todo.ListPermission do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:list_id, :user_id]}
  schema "list_permissions" do
    field :read, :boolean, default: false
    field :write, :boolean, default: false
    field :user_id, :id
    field :list_id, :id

    timestamps()
  end

  @doc false
  def changeset(list_permission, attrs) do
    list_permission
    |> cast(attrs, [:read, :write])
    |> validate_required([:read, :write])
  end
end
