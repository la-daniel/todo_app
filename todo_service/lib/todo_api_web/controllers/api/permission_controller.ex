defmodule TodoApiWeb.PermissionController do
  use TodoApiWeb, :controller

  alias TodoApi.Todo
  alias TodoApi.Todo.Permission

  action_fallback TodoApiWeb.FallbackController

  def index(conn, _params) do
    permissions = Todo.list_permissions()
    render(conn, "index.json", permissions: permissions)
  end

  def create(conn, %{"permission" => permission_params}) do
    with {:ok, %Permission{} = permission} <- Todo.create_permission(permission_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.permission_path(conn, :show, permission))
      |> render("show.json", permission: permission)
    end
  end

  def show(conn, %{"id" => id}) do
    permission = Todo.get_permission!(id)
    render(conn, "show.json", permission: permission)
  end

  def update(conn, %{"id" => id, "permission" => permission_params}) do
    permission = Todo.get_permission!(id)

    with {:ok, %Permission{} = permission} <- Todo.update_permission(permission, permission_params) do
      render(conn, "show.json", permission: permission)
    end
  end

  def delete(conn, %{"id" => id}) do
    permission = Todo.get_permission!(id)

    with {:ok, %Permission{}} <- Todo.delete_permission(permission) do
      send_resp(conn, :no_content, "")
    end
  end
end
