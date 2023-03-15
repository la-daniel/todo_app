defmodule TodoApi.Todo.UserRegister do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :password, :string, redact: true
    field :password_confirmation, :string, redact: true
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
  end
end
