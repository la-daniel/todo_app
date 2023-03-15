defmodule TodoApiWeb.TaskPermissionView do
  use TodoApiWeb, :view
  alias TodoApiWeb.TaskPermissionView

  def render("index.json", %{task_permissions: task_permissions}) do
    %{data: render_many(task_permissions, TaskPermissionView, "task_permission.json")}
  end

  def render("show.json", %{task_permission: task_permission}) do
    %{data: render_one(task_permission, TaskPermissionView, "task_permission.json")}
  end

  def render("task_permission.json", %{task_permission: task_permission}) do
    %{
      id: task_permission.id,
      read: task_permission.read,
      write: task_permission.write
    }
  end
end
