defmodule TodoApiWeb.Todo do
  use TodoApiWeb, :live_view
  require Logger
  require Phoenix.Component
  # alias Mix.Tasks.Iex
  alias Mix.Task
  alias TodoApi.Todo.Task
  alias TodoApi.Todo.List
  alias TodoApi.Todo.Comment
  alias TodoApiWeb.TodoCont

  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign_token(session)
     |> assign_todo()
     |> assign_todo_list()
     |> assign_todo_changeset()
     |> assign_list_changeset()
     |> assign_changeset_edit()
     |> assign_changeset_title()
     |> assign_show_create()
     |> assign_comment_changeset()
     |> assign_show_edit_title()
     |> assign_show_comments()
     # TODO make this current_user with all user attrs available later?
     |> assign_email(session)
     # getting session ID from
     |> assign_user_id(session)}
  end

  def assign_user_id(socket, session) do
    user = session["current_user"]

    socket
    |> assign(:current_user_id, user["id"])
  end

  def assign_token(socket, session) do
    token = session["token"]

    socket
    |> assign(:token, token)
  end

  def assign_email(socket, session) do
    user = session["current_user"]

    socket
    |> assign(:email, user["email"])
  end

  def assign_show_comments(socket) do
    socket
    |> assign(:selectedCommentsId, 0)
    |> assign(:showSelectedComments, false)
  end

  def assign_todo_list(socket) do
    client = TodoCont.client(socket)
    {:ok, response} = TodoCont.get_all_lists(client)

    socket
    |> assign(:lists, response.body["data"])

    # IO.inspect(response)
    # with %{"data" => []} = %{"data" => []} <- response.body do
    #   socket
    #   |> assign(:lists, response.body["data"])
    # else
    #   %{"error" => %{"code" => 401, "message" => "Not authenticated"}} ->
    #     socket
    #     # |> push_event("toast", %{message: "Session Expired: You need to relogin!!"})
    #     # |> push_redirect(to: "/logout")
    # end

    # {:ok, response} = TodoCont.get_all_lists()
    # IO.inspect(response.body)
  end

  def assign_todo(socket) do
    socket
    |> assign(:todo, %Task{})
  end

  def assign_show_edit_title(socket) do
    socket
    |> assign(:showEditListTitle, false)
    |> assign(:selectedEditListId, 0)
  end

  def assign_show_create(socket) do
    socket
    |> assign(:showCreateTask, false)
    |> assign(:showCreateList, false)
    |> assign(:selectedCreateListId, 0)
  end

  def assign_changeset_title(socket) do
    assign(socket, %{title_changeset: List.title_changeset(%List{}, %{})})
  end

  def assign_todo_changeset(socket) do
    assign(socket, %{task_changeset: TodoCont.change_todo(%Task{})})
  end

  def assign_list_changeset(socket) do
    assign(socket, %{list_changeset: List.changeset(%List{}, %{})})
  end

  def assign_changeset_edit(socket) do
    assign(socket, %{changeset_edit: TodoCont.change_todo(%Task{})})
  end

  def assign_comment_changeset(socket) do
    assign(socket, %{comment_changeset: Comment.changeset(%Comment{}, %{})})
  end

  def handle_event("delete", params, socket) do
    del_todo = params["todo"]
    IO.inspect(del_todo)
    # Users.delete_todo(del_todo)
    client = TodoCont.client(socket)
    {:ok, response} = TodoCont.delete_task(client, del_todo)

    with %{"data" => deleted_data} = %{"data" => %{}} <- response.body do
      client = TodoCont.client(socket)
      {:ok, response} = TodoCont.get_all_lists(client)
      IO.inspect(deleted_data)
      deleted_task_name = deleted_data["title"]

      {:noreply,
       socket
       |> push_event("toast", %{message: "Deleted task " <> deleted_task_name <> " successfully"})
       |> assign(lists: response.body["data"])}
    else
      %{"error" => %{"code" => 401, "message" => "Not authenticated"}} ->
        {:noreply,
         socket
         |> push_event("toast", %{message: "Session Expired: You need to relogin!"})
         |> push_redirect(to: "/logout")}
    end
  end

  def handle_event("delete_list", params, socket) do
    del_list = params["list-id"]
    IO.inspect(del_list)
    # Users.delete_todo(del_todo)
    client = TodoCont.client(socket)
    {:ok, response} = TodoCont.delete_list(client, del_list)

    with %{"data" => deleted_data} = %{"data" => %{}} <- response.body do
      IO.inspect(deleted_data)
      client = TodoCont.client(socket)
      {:ok, response} = TodoCont.get_all_lists(client)
      IO.inspect(deleted_data)
      deleted_list_name = deleted_data["title"]

      {:noreply,
       socket
       |> push_event("toast", %{message: "Deleted list " <> deleted_list_name <> " successfully"})
       |> assign(lists: response.body["data"])}
    else
      %{"error" => %{"code" => 401, "message" => "Not authenticated"}} ->
        {:noreply,
         socket
         |> push_event("toast", %{message: "Session Expired: You need to relogin!"})
         |> push_redirect(to: "/logout")}
    end
  end

  def handle_event("delete_comment", params, socket) do
    del_comment = params["comment-id"]
    Logger.info(del_comment)
    # Users.delete_todo(del_todo)
    client = TodoCont.client(socket)
    {:ok, response} = TodoCont.delete_comment(client, del_comment)

    with %{"data" => deleted_data} = %{"data" => %{}} <- response.body do
      client = TodoCont.client(socket)
      {:ok, response} = TodoCont.get_all_lists(client)
      IO.inspect(deleted_data)
      deleted_comment_name = deleted_data["comment"]

      {:noreply,
       socket
       |> push_event("toast", %{
         message: "Deleted comment " <> deleted_comment_name <> " successfully"
       })
       |> assign(lists: response.body["data"])}
    else
      %{"error" => %{"code" => 401, "message" => "Not authenticated"}} ->
        {:noreply,
         socket
         |> push_event("toast", %{message: "Session Expired: You need to relogin!"})
         |> push_redirect(to: "/logout")}
    end
  end

  def handle_event("validate_list", %{"list" => params}, socket) do
    changeset =
      %List{}
      |> List.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, list_changeset: changeset)}
  end

  def handle_event("validate_task", %{"task" => params}, socket) do
    changeset =
      %Task{}
      |> Task.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, task_changeset: changeset)}
  end

  def handle_event("validate_comment", %{"comment" => params}, socket) do
    changeset =
      %Comment{}
      |> Comment.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, comment_changeset: changeset)}
  end

  def handle_event("validate_edit", %{"todo" => params}, socket) do
    changeset =
      %Task{}
      |> TodoCont.change_todo(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset_edit: changeset)}
  end

  def handle_event("validate_title", %{"list" => params}, socket) do
    changeset =
      %List{}
      |> List.title_changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset_edit: changeset)}
  end

  def handle_event("edit", %{"task" => todo_params}, socket) do
    # {:ok, response} = TodoCont.get_todo(todo_params["id"])
    # update_todo = response.body
    # IO.inspect(update_todo)
    client = TodoCont.client(socket)
    {:ok, response} = TodoCont.update_task(client, todo_params)

    with %{"data" => edited_data} = %{"data" => %{}} <- response.body do
      client = TodoCont.client(socket)
      {:ok, response} = TodoCont.get_all_lists(client)
      IO.inspect(edited_data)
      edited_task_title = edited_data["title"]
      IO.inspect(TodoApi.Todo.Task.changeset(%Task{}, %{}))

      {:noreply,
       socket
       |> push_event("toast", %{message: "Edited task " <> edited_task_title <> " successfully"})
       |> assign(
         lists: response.body["data"],
         changeset_edit: TodoApi.Todo.Task.changeset(%Task{}, %{})
       )}
    else
      %{"errors" => error} = %{"errors" => %{}} ->
        IO.inspect(error)
        header = ["Errors: \n "]

        title_errors =
          if Map.has_key?(error, "title"), do: "title: " <> "#{error["title"]}", else: ""

        IO.inspect(title_errors)
        error_list = Enum.join([header, title_errors], " ")
        IO.inspect(error_list)
        {:noreply, push_event(socket, "toast", %{message: error_list})}

      %{"error" => %{"code" => 401, "message" => "Not authenticated"}} ->
        {:noreply,
         socket
         |> push_event("toast", %{message: "Session Expired: You need to relogin!"})
         |> push_redirect(to: "/logout")}
    end

    # Ecto.Changeset.change(socket.assigns.changeset_edit, id: 0)
    # assign(socket, %{changeset_edit: TodoCont.change_todo(%Task{})})
    # Logger.info(socket.assigns.changeset_edit)
  end

  def handle_event("move", todo_params, socket) do
    Logger.debug(todo_params)

    client = TodoCont.client(socket)

    TodoCont.change_task_order(
      client,
      String.to_integer(todo_params["todo-id"], 10),
      String.to_integer(todo_params["move-to"], 10)
    )

    {:ok, response} = TodoCont.get_all_lists(client)

    {:noreply,
     socket
     |> push_event("toast", %{message: "Successfully moved task."})
     |> assign(:lists, response.body["data"])}
  end

  def handle_event("save_list", %{"list" => list_params}, socket) do
    client = TodoCont.client(socket)
    list_params = Map.put(list_params, "user_id", socket.assigns.current_user_id)
    {:ok, response} = TodoCont.create_list(client, list_params)

    with %{"data" => created_data} = %{"data" => %{}} <- response.body do
      client = TodoCont.client(socket)
      {:ok, response} = TodoCont.get_all_lists(client)
      IO.inspect(created_data)
      created_list_name = created_data["title"]

      {:noreply,
       socket
       |> push_event("toast", %{message: "Created list " <> created_list_name <> " successfully"})
       |> assign(
         lists: response.body["data"],
         list_changeset: List.changeset(%List{}, %{}),
         showCreateList: false
       )}
    else
      %{"errors" => error} = %{"errors" => %{}} ->
        IO.inspect(error)
        header = ["Errors: \n "]

        title_errors =
          if Map.has_key?(error, "title"), do: "title: " <> "#{error["title"]}", else: ""

        IO.inspect(title_errors)
        error_list = Enum.join([header, title_errors], " ")
        IO.inspect(error_list)
        {:noreply, push_event(socket, "toast", %{message: error_list})}

      %{"error" => %{"code" => 401, "message" => "Not authenticated"}} ->
        {:noreply,
         socket
         |> push_event("toast", %{message: "Session Expired: You need to relogin!"})
         |> push_redirect(to: "/logout")}
    end
  end

  def handle_event("save_comment", %{"comment" => comment_params}, socket) do
    client = TodoCont.client(socket)
    {:ok, response} = TodoCont.add_comment(client, comment_params)

    with %{"data" => created_data} = %{"data" => %{}} <- response.body do
      client = TodoCont.client(socket)
      {:ok, response} = TodoCont.get_all_lists(client)
      IO.inspect(created_data)
      created_comment_name = created_data["comment"]

      {:noreply,
       socket
       |> push_event("toast", %{
         message: "Created comment " <> created_comment_name <> " successfully"
       })
       |> assign(
         lists: response.body["data"],
         comment_changeset: Comment.changeset(%Comment{}, %{})
       )}
    else
      %{"errors" => error} = %{"errors" => %{}} ->
        IO.inspect(error)
        header = ["Errors: \n "]

        comment_errors =
          if Map.has_key?(error, "comment"), do: "comment: " <> "#{error["comment"]}", else: ""

        IO.inspect(comment_errors)
        error_list = Enum.join([header, comment_errors], " ")
        IO.inspect(error_list)
        {:noreply, push_event(socket, "toast", %{message: error_list})}

      %{"error" => %{"code" => 401, "message" => "Not authenticated"}} ->
        {:noreply,
         socket
         |> push_event("toast", %{message: "Session Expired: You need to relogin!"})
         |> push_redirect(to: "/logout")}
    end
  end

  def handle_event("save_task", %{"task" => task_params}, socket) do
    # IO.inspect(task_params)
    # IO.inspect(socket.assigns.selectedCreateListId)

    task_params =
      Map.put(task_params, "list_id", Integer.to_string(socket.assigns.selectedCreateListId))

    client = TodoCont.client(socket)
    {:ok, response} = TodoCont.create_task(client, task_params)

    with %{"data" => created_data} = %{"data" => %{}} <- response.body do
      client = TodoCont.client(socket)
      {:ok, response} = TodoCont.get_all_lists(client)
      IO.inspect(created_data)
      created_task_name = created_data["title"]
      IO.inspect(created_task_name)

      {:noreply,
       socket
       |> push_event("toast", %{message: "Created task " <> created_task_name <> " successfully"})
       |> assign(
         lists: response.body["data"],
         task_changeset: TodoCont.change_todo(%Task{}),
         showCreateTask: false
       )}
    else
      %{"errors" => error} = %{"errors" => %{}} ->
        IO.inspect(error)
        header = ["Errors: \n "]

        title_errors =
          if Map.has_key?(error, "title"), do: "title: " <> "#{error["title"]}\n", else: ""

        detail_errors =
          if Map.has_key?(error, "detail"), do: "detail: " <> "#{error["detail"]}\n", else: ""

        IO.inspect(title_errors)
        IO.inspect(detail_errors)
        error_list = Enum.join([header, title_errors, detail_errors], " ")
        IO.inspect(error_list)
        {:noreply, push_event(socket, "toast", %{message: error_list})}

      %{"error" => %{"code" => 401, "message" => "Not authenticated"}} ->
        {:noreply,
         socket
         |> push_event("toast", %{message: "Session Expired: You need to relogin!"})
         |> push_redirect(to: "/logout")}
    end
  end

  def handle_event("toggle_create_list", _params, socket) do
    Logger.info("CREATE TOGGLED!")
    {:noreply, assign(socket, :showCreateList, !socket.assigns.showCreateList)}
  end

  def handle_event("toggle_create_task", params, socket) do
    {:noreply,
     assign(socket,
       showCreateTask: !socket.assigns.showCreateTask,
       selectedCreateListId: String.to_integer(params["list_id"])
     )}
  end

  def handle_event("edit_list_title", params, socket) do
    list_id = params["list-id"]
    client = TodoCont.client(socket)
    {:ok, response} = TodoCont.get_list(client, list_id)
    list_body = response.body["data"]

    {:noreply,
     assign(socket,
       selectedEditListId: String.to_integer(params["list-id"]),
       showEditListTitle: true,
       title_changeset: List.title_changeset(%List{}, list_body)
     )}
  end

  def handle_event("edit_list_title_cancel", _params, socket) do
    IO.inspect("HATDOG")

    {:noreply,
     assign(socket,
       showEditListTitle: false,
       title_changeset: List.title_changeset(%List{}, %{})
     )}
  end

  def handle_event("start_edit", todo_params, socket) do
    client = TodoCont.client(socket)
    {:ok, response} = TodoCont.get_task(client, todo_params["todo"])
    todo_body = response.body["data"]
    IO.inspect("THEBODY")
    IO.inspect(todo_body)

    {:ok, todo} =
      %Task{}
      |> Task.changeset(todo_body)
      |> Ecto.Changeset.apply_action(:update)

    IO.inspect(todo)
    # Logger.info(todo)
    IO.inspect("AHAH")
    IO.inspect(TodoCont.change_todo(todo).data)
    {:noreply, assign(socket, changeset_edit: TodoCont.change_todo(todo))}
  end

  def handle_event("edit_title", %{"list" => title_params}, socket) do
    list_id = title_params["id"]
    client = TodoCont.client(socket)
    {:ok, response} = TodoCont.get_list(client, list_id)
    list_body = response.body["data"]
    IO.inspect(list_body)
    updatedList = Map.merge(list_body, title_params)
    {:ok, response} = TodoCont.update_list(client, updatedList)

    with %{"data" => edited_data} = %{"data" => %{}} <- response.body do
      client = TodoCont.client(socket)
      {:ok, response} = TodoCont.get_all_lists(client)
      IO.inspect(edited_data)
      edited_list_title = edited_data["title"]

      {:noreply,
       socket
       |> push_event("toast", %{message: "Edited list " <> edited_list_title <> " successfully"})
       |> assign(socket,
         lists: response.body["data"],
         changeset_edit: TodoCont.change_todo(%Task{})
       )}
    else
      %{"errors" => error} = %{"errors" => %{}} ->
        IO.inspect(error)
        header = ["Errors: \n "]

        title_errors =
          if Map.has_key?(error, "title"), do: "title: " <> "#{error["title"]}", else: ""

        IO.inspect(title_errors)
        error_list = Enum.join([header, title_errors], " ")
        IO.inspect(error_list)
        {:noreply, push_event(socket, "toast", %{message: error_list})}

      %{"error" => %{"code" => 401, "message" => "Not authenticated"}} ->
        {:noreply,
         socket
         |> push_event("toast", %{message: "Session Expired: You need to relogin!"})
         |> push_redirect(to: "/logout")}
    end

    {:noreply,
     assign(socket,
       lists: response.body["data"],
       list_changeset: List.changeset(%List{}, %{}),
       showEditListTitle: false
     )}
  end

  def handle_event("cancel_edit", _todo_params, socket) do
    {:noreply, assign(socket, %{changeset_edit: TodoCont.change_todo(%Task{})})}
  end

  # @selectedCommentsId and @showSelectedComments
  def handle_event("open_comments", params, socket) do
    {:noreply,
     assign(socket,
       selectedCommentsId: String.to_integer(params["todo"]),
       showSelectedComments: true
     )}
  end

  def handle_event("close_comments", _params, socket) do
    {
      :noreply,
      socket
      |> assign(showSelectedComments: false)
      # |> push_event("toast", %{message: "closed comments"})
    }
  end

  def handle_event(
        "dropped",
        %{
          "draggedId" => dragged_id,
          "dropzoneId" => drop_zone_id,
          "newOrder" => new_order,
          "new_list_id" => new_list_id
        },
        %{assigns: _assigns} = socket
      ) do
    IO.inspect(dragged_id)

    IO.inspect(drop_zone_id)

    IO.inspect(new_order)
    IO.puts("END DRAG LOGS")
    client = TodoCont.client(socket)

    {:ok, response} =
      TodoCont.change_task_order(
        client,
        String.to_integer(dragged_id, 10),
        new_order,
        String.to_integer(new_list_id)
      )

    IO.inspect(response)

    with %{"data" => moved_data} = %{"data" => %{}} <- response.body do
      client = TodoCont.client(socket)
      {:ok, response} = TodoCont.get_all_lists(client)
      IO.inspect(moved_data)
      created_list_name = moved_data["title"]

      {:noreply,
       socket
       |> push_event("toast", %{message: "Moved task " <> created_list_name <> " successfully"})
       |> assign(
         lists: response.body["data"],
         list_changeset: List.changeset(%List{}, %{})
       )}
    else
      "" ->
        {:ok, response} = TodoCont.get_all_lists(client)

        {:noreply,
         socket
         |> push_event("toast", %{message: "Something went wrong woth changing task orders."})
         |> assign(
           lists: response.body["data"],
           list_changeset: List.changeset(%List{}, %{})
         )}

      %{"error" => %{"code" => 401, "message" => "Not authenticated"}} ->
        {:noreply,
         socket
         |> push_event("toast", %{message: "Session Expired: You need to relogin!"})
         |> push_redirect(to: "/logout")}
    end
  end

  def handle_event("toast_test", _params, socket) do
    {:noreply,
     push_event(socket, "toast", %{message: "Your record has been created successfully"})}
  end
end
