defmodule TodoApiWeb.API.V1.UserController do
  use TodoApiWeb, :controller

  alias TodoApi.Todo
  alias TodoApi.Users.User

  action_fallback TodoApiWeb.FallbackController

  def index(conn, _params) do
    users = Todo.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Todo.create_user(user_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Todo.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Todo.get_user!(id)

    with {:ok, %User{} = user} <- Todo.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Todo.get_user!(id)

    with {:ok, %User{}} <- Todo.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_all_todos(conn, _params) do
    users = Todo.get_all_todos()
    # IO.inspect(users)
    # with {:ok, %User{}} <- user do
      render(conn, "index_all.json", users: elem(users, 0))
    # end
  end
end
