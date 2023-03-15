defmodule TodoApiWeb.API.ListController do
  use TodoApiWeb, :controller

  alias TodoApi.ListPermission
  alias TodoApi.Todo
  alias TodoApi.Todo.List
  alias TodoApi.Todo.ListPermission
  action_fallback TodoApiWeb.FallbackController

  def index(conn, _params) do
    lists = Todo.list_lists()
    render(conn, "index.json", lists: lists)
  end

  def create(conn, %{"list" => list_params}) do
    IO.inspect(list_params)
    latestOrder = Todo.get_largest_list_order(list_params["user_id"])
    list_params = Map.put(list_params, "order", latestOrder)
    IO.inspect(list_params)

    with {:ok, %List{} = list} <- Todo.create_list(list_params) do
      # IO.inspect(list.id) # right way to access
      # IO.inspect(list["user_id"])
      with {:ok, %ListPermission{} = permission} <-
             Todo.create_list_permission(%{"user_id" => list.user_id, "list_id" => list.id}) do
        IO.inspect(permission)
        IO.inspect(list)
        conn
        |> put_status(:created)
        # |> put_resp_header("location", Routes.list_path(conn, :show, list))
        |> render("show.json", list: list)
      end

    end
  end

  def show(conn, %{"id" => id}) do
    list = Todo.get_list!(id)
    render(conn, "show.json", list: list)
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Todo.get_list!(id)

    with {:ok, %List{} = list} <- Todo.update_list(list, list_params) do
      render(conn, "show.json", list: list)
    end
  end

  def delete(conn, %{"id" => id}) do
    list = Todo.get_list!(id)

    with {:ok, %List{}} <- Todo.delete_list(list) do
      render(conn, "show.json", list: list)
    end
  end

  def get_all_lists(conn, _params) do
    IO.inspect(conn)
    lists = Todo.get_all_lists()
    # with {:ok, %User{}} <- user do
    render(conn, "index_all.json", lists: elem(lists, 0))
    # end
  end
end
