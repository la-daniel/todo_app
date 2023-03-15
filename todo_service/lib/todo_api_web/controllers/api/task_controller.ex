defmodule TodoApiWeb.API.TaskController do
  use TodoApiWeb, :controller

  alias TodoApi.Todo
  alias TodoApi.Todo.Task

  action_fallback TodoApiWeb.FallbackController

  def index(conn, _params) do
    tasks = Todo.list_tasks()
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, %{"task" => task_params}) do
    latestOrder =  Todo.get_largest_task_order(String.to_integer(task_params["list_id"]))
    task_params = Map.put(task_params, "order", latestOrder)
    IO.inspect(task_params)
    # task_params = Map.put(task_params, "list_id", String.to_integer(task_params["list_id"]))
    with {:ok, %Task{} = task} <- Todo.create_task(task_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.task_path(conn, :show, task))
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Todo.get_task!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Todo.get_task!(id)

    with {:ok, %Task{} = task} <- Todo.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Todo.get_task!(id)

    with {:ok, %Task{}} <- Todo.delete_task(task) do
      conn
      |> render("show.json", task: task)
    end
  end

  def change_order(conn, %{"id" => id, "newListOrder" => newListOrder}) do
    todo = Todo.get_task!(id)
    IO.inspect(todo)
    IO.inspect(newListOrder)
    with {:ok, %Task{} = task} <- Todo.change_todo_order(id, newListOrder) do
      IO.inspect(task)
      render(conn, "show.json", task: task)
    else
      err -> err
      send_resp(conn, :no_content, "")
    end
  end



end
