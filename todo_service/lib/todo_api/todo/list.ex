defmodule TodoApi.Todo.List do
  use Ecto.Schema
  import Ecto.Changeset

 @derive {Jason.Encoder, only: [:order, :title, :id, :tasks, :list_permissions, :user]} 
  schema "lists" do
    field :order, :integer
    field :title, :string
    field :assigned_to, :id
    belongs_to :user, TodoApi.Todo.User  # this was added
    has_many :tasks, TodoApi.Todo.Task
    has_many :list_permissions, TodoApi.Todo.ListPermission
    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:order, :title, :user_id])
    |> validate_required([:order, :title, :user_id])
    |> cast_assoc(:tasks)
    |> cast_assoc(:user)
    |> cast_assoc(:list_permissions)
  end
end
