defmodule TodoApi.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:detail, :title, :id, :comments, :order, :list_id, :user_id]}
  schema "tasks" do
    field :detail, :string
    field :order, :integer
    field :title, :string
    # field :list_id, :id
    field :assigned_to, :id
    # field :user_id, :id
    belongs_to :user, TodoApi.Todo.User
    belongs_to :list, Todo.List  # this was added
    has_many :comments, TodoApi.Todo.Comment
    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:detail, :title, :order, :list_id, :user_id])
    |> validate_required([:detail, :title, :order, :list_id, :user_id])
    |> cast_assoc(:comments)
    |> cast_assoc(:user)
  end
end
