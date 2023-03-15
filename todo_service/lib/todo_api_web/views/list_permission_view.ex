defmodule TodoApiWeb.ListPermissionView do
  use TodoApiWeb, :view
  alias TodoApiWeb.ListPermissionView

  def render("index.json", %{list_permissions: list_permissions}) do
    %{data: render_many(list_permissions, ListPermissionView, "list_permission.json")}
  end

  def render("show.json", %{list_permission: list_permission}) do
    %{data: render_one(list_permission, ListPermissionView, "list_permission.json")}
  end

  def render("list_permission.json", %{list_permission: list_permission}) do
    %{
      id: list_permission.id,
      read: list_permission.read,
      write: list_permission.write
    }
  end
end
