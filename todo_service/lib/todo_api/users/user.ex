defmodule TodoApi.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    pow_user_fields()

    has_many :lists, TodoApi.Todo.List  # this was added
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> cast_assoc(:lists)
  end

end
