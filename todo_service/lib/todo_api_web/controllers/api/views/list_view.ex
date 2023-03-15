defmodule TodoApiWeb.API.ListView do
  use TodoApiWeb, :view
  alias TodoApiWeb.API.ListView

  def render("index.json", %{lists: lists}) do
    %{data: render_many(lists, ListView, "list.json")}
  end

  def render("index_all.json", %{lists: lists}) do
    %{data: render_many(lists, ListView, "all.json")}
  end

  def render("show.json", %{list: list}) do
    %{data: render_one(list, ListView, "list.json")}
  end

  def render("list.json", %{list: list}) do
    %{
      id: list.id,
      order: list.order,
      title: list.title
    }
  end

  def render("all.json", %{list: list}) do
    # IO.inspect("list view")
    # IO.inspect(list)
    %{
      id: list.id,
      order: list.order,
      title: list.title,
      tasks: list.tasks,
      user: list.user,
      list_permissions: list.list_permissions
    }
  end
end
