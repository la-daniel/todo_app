defmodule TodoApiWeb.ListPermissionController do
  use TodoApiWeb, :controller

  alias TodoApi.Todo
  alias TodoApi.Todo.ListPermission

  action_fallback TodoApiWeb.FallbackController

  def index(conn, _params) do
    list_permissions = Todo.list_list_permissions()
    render(conn, "index.json", list_permissions: list_permissions)
  end

  def create(conn, %{"list_permission" => list_permission_params}) do
    with {:ok, %ListPermission{} = list_permission} <- Todo.create_list_permission(list_permission_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.list_permission_path(conn, :show, list_permission))
      |> render("show.json", list_permission: list_permission)
    end
  end

  def show(conn, %{"id" => id}) do
    list_permission = Todo.get_list_permission!(id)
    render(conn, "show.json", list_permission: list_permission)
  end

  def update(conn, %{"id" => id, "list_permission" => list_permission_params}) do
    list_permission = Todo.get_list_permission!(id)

    with {:ok, %ListPermission{} = list_permission} <- Todo.update_list_permission(list_permission, list_permission_params) do
      render(conn, "show.json", list_permission: list_permission)
    end
  end

  def delete(conn, %{"id" => id}) do
    list_permission = Todo.get_list_permission!(id)

    with {:ok, %ListPermission{}} <- Todo.delete_list_permission(list_permission) do
      send_resp(conn, :no_content, "")
    end
  end
end
