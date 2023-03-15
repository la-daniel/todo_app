defmodule TodoApi.Todo.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :order, :integer
    field :title, :string
    field :user_id, :id
    field :assigned_to, :id
    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [ :title])
    |> validate_required([:title])
  end

  def title_changeset(list, attrs) do
    list
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
