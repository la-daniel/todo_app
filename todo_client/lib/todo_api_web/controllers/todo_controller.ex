defmodule TodoApiWeb.TodoController do
  use TodoApiWeb, :controller

  alias TodoApi.Users
  alias TodoApi.Todo.Task

  action_fallback TodoApiWeb.FallbackController

  def index(conn, _params) do
    todos = Users.list_todos()
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    # IO.puts("HALLO")
    # IO.puts(Users.get_largest_order())
    latestOrder = Users.get_largest_order()
    todo_params = Map.put(todo_params, "order", latestOrder)

    with {:ok, %Task{} = todo} <- Users.create_todo(todo_params) do
      # IO.inspect(todo)
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.todo_path(conn, :show, todo))
      |> render("show.json", todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Users.get_todo!(id)
    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Users.get_todo!(id)

    with {:ok, %Task{} = todo} <- Users.update_todo(todo, todo_params) do
      render(conn, "show.json", todo: todo)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Users.get_todo!(id)

    with {:ok, %Task{}} <- Users.delete_todo(todo) do
      render(conn, "show.json", todo: todo)
    end
  end

  def change_order(conn, %{"id" => id, "newListOrder" => newListOrder}) do
    todo = Users.get_todo!(id)

    with {:ok, %Task{} = todo} <- Users.change_todo_order(id, newListOrder) do
      render(conn, "show.json", todo: todo)
    end
  end
end
