defmodule TodoApiWeb.TaskPermissionController do
  use TodoApiWeb, :controller

  alias TodoApi.Todo
  alias TodoApi.Todo.TaskPermission

  action_fallback TodoApiWeb.FallbackController

  def index(conn, _params) do
    task_permissions = Todo.list_task_permissions()
    render(conn, "index.json", task_permissions: task_permissions)
  end

  def create(conn, %{"task_permission" => task_permission_params}) do
    with {:ok, %TaskPermission{} = task_permission} <- Todo.create_task_permission(task_permission_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.task_permission_path(conn, :show, task_permission))
      |> render("show.json", task_permission: task_permission)
    end
  end

  def show(conn, %{"id" => id}) do
    task_permission = Todo.get_task_permission!(id)
    render(conn, "show.json", task_permission: task_permission)
  end

  def update(conn, %{"id" => id, "task_permission" => task_permission_params}) do
    task_permission = Todo.get_task_permission!(id)

    with {:ok, %TaskPermission{} = task_permission} <- Todo.update_task_permission(task_permission, task_permission_params) do
      render(conn, "show.json", task_permission: task_permission)
    end
  end

  def delete(conn, %{"id" => id}) do
    task_permission = Todo.get_task_permission!(id)

    with {:ok, %TaskPermission{}} <- Todo.delete_task_permission(task_permission) do
      send_resp(conn, :no_content, "")
    end
  end
end
