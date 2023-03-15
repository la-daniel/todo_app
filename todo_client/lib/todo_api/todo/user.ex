defmodule TodoApi.Todo.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :password, :string, redact: true
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end
end
