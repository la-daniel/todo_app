defmodule TodoApiWeb.TodoCont do
  # use Tesla
  require Logger
  # alias Tesla.Multipart
  # plug Tesla.Middleware.Logger
  # alias TodoApi.Todo.List
  alias TodoApi.Todo.Task
  # plug Tesla.Middleware.BaseUrl, "http://172.21.0.3:4001"
  # plug Tesla.Middleware.Headers, [{"authorization", "SFMyNTY.YjllMWE0M2ItMzE1MS00Y2VhLTgwOGYtMzUzZDUyN2I1NWE2.vDCFnMcxnQR4UXE0RjAWZpmzl6LA8NjcyJOgct-sqLY"}]
  # Tesla.Builder.plug(Tesla.Middleware.BaseUrl, "http://localhost:4001/api")
  # Tesla.Builder.plug(Tesla.Middleware.JSON)
  # Tesla.Builder.plug(Tesla.Middleware.FormUrlencoded)

  # build dynamic client based on runtime arguments, for the token
  def client(socket) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "http://172.21.0.3:4001/api"},
      Tesla.Middleware.JSON,
      Tesla.Middleware.FormUrlencoded,
      # {Tesla.Middleware.UnauthorizedChecker, socket},
      {Tesla.Middleware.Headers, [{"authorization", socket.assigns.token }]}
    ]
    Tesla.client(middleware)
  end

  def list_tasks(client) do
    Tesla.get(client, "/tasks/")
  end

  def get_task(client, id) do
    Tesla.get(client, "/tasks/" <> id)
  end

  def delete_task(client, id) do
    IO.inspect(id)
    Tesla.delete(client, "/tasks/" <> id)
  end

  def update_task(client, task) do
    Logger.info("HALLO")
    IO.inspect(task)
    # mp = Multipart.new()
    # |> Multipart.add_content_type_param("charset=utf-8")
    # |> Multipart.add_field("todo", '{"detail": "Pwet", "id": "3", "title": "dsdTest Title 3"}')
    # IO.inspect(mp)
    Tesla.patch(client, "/tasks/" <> task["id"], %{"task" => task})
  end

  def change_task_order(client, id, newListOrder, new_list_id) do
    Tesla.post(client, "/change_order", %{"id" => id, "newListOrder" => newListOrder, "new_list_id" => new_list_id})
  end

  def create_task(client, task_params) do
    IO.inspect(task_params)
    Tesla.post(client, "/tasks/", %{"task" => task_params})
  end

  def get_lists(client ) do
    Tesla.get(client, "/lists/")
  end

  def create_list(client, list_params) do
    # IO.inspect(list_params)
    # IO.inspect("CREATE CHANGESET")
    # IO.inspect(List.changeset(%List{}, list_params))
    Tesla.post(client, "/lists/", %{"list" => list_params})
  end

  def change_todo( %Task{} = todo, attrs \\ %{}) do
    Task.changeset(todo, attrs)
  end

  def get_all_todos(client ) do
    Tesla.get(client, "/get_all_todos/")
  end

  def get_all_lists(client ) do
    Tesla.get(client, "/get_all_lists/")
  end

  def get_list(client, id) do
    IO.inspect("Hallo")
    IO.inspect(id)
    Tesla.get(client, "/lists/" <> id)
  end

  def update_list(client, list) do
    Logger.info("HALLO")
    IO.inspect(list)
    # mp = Multipart.new()
    # |> Multipart.add_content_type_param("charset=utf-8")
    # |> Multipart.add_field("todo", '{"detail": "Pwet", "id": "3", "title": "dsdTest Title 3"}')
    # IO.inspect(mp)
    Tesla.patch(client, "/lists/" <> list["id"], %{"list" => list})
  end

  def delete_list(client, id) do
    IO.inspect(id)
    Tesla.delete(client, "/lists/" <> id)
  end

  def delete_comment(client, id) do
    IO.inspect(id)
    Tesla.delete(client, "/comments/" <> id)
  end

  def add_comment(client, comment) do
    Tesla.post(client, "/comments/", %{"comment" => comment})
  end
end
