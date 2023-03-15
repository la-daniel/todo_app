defmodule TodoApi.Todo.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:comment, :id ]} 
  schema "comments" do
    field :comment, :string
    # field :task_id, :id
    belongs_to :task, TodoApi.Todo.Task
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:comment, :task_id])
    |> validate_required([:comment, :task_id])
  end
end
