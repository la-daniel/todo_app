defmodule TodoApi.Todo do
  @moduledoc """
  The Todo context.
  """

  import Ecto.Query, warn: false
  alias Mix.Task
  alias TodoApi.Repo

  alias TodoApi.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)


  def get_user_by_email(email) do

    query =
      from u in "users",
        where: ^email == u.email,
        select: [u.email, u.id]

    user = Repo.one(query)
  end
  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias TodoApi.Todo.List

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  def list_lists do
    Repo.all(List)
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(id), do: Repo.get!(List, id)

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    Repo.delete(list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  def change_list(%List{} = list, attrs \\ %{}) do
    List.changeset(list, attrs)
  end

  alias TodoApi.Todo.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    # Repo.all(Task)
    Repo.all(
      from t in "tasks",
        order_by: [asc: t.order],
        select: [:id, :detail, :title, :order]
    )

  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  alias TodoApi.Todo.Permission

  @doc """
  Returns the list of permissions.

  ## Examples

      iex> list_permissions()
      [%Permission{}, ...]

  """
  def list_permissions do
    Repo.all(Permission)
  end

  @doc """
  Gets a single permission.

  Raises `Ecto.NoResultsError` if the Permission does not exist.

  ## Examples

      iex> get_permission!(123)
      %Permission{}

      iex> get_permission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_permission!(id), do: Repo.get!(Permission, id)

  @doc """
  Creates a permission.

  ## Examples

      iex> create_permission(%{field: value})
      {:ok, %Permission{}}

      iex> create_permission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_permission(attrs \\ %{}) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a permission.

  ## Examples

      iex> update_permission(permission, %{field: new_value})
      {:ok, %Permission{}}

      iex> update_permission(permission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_permission(%Permission{} = permission, attrs) do
    permission
    |> Permission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a permission.

  ## Examples

      iex> delete_permission(permission)
      {:ok, %Permission{}}

      iex> delete_permission(permission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_permission(%Permission{} = permission) do
    Repo.delete(permission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking permission changes.

  ## Examples

      iex> change_permission(permission)
      %Ecto.Changeset{data: %Permission{}}

  """
  def change_permission(%Permission{} = permission, attrs \\ %{}) do
    Permission.changeset(permission, attrs)
  end


  def set_last_nil_order_to_curr_id(id) do
    query =
      from t in "todos",
        where: is_nil(t.order),
        select: t.id

    todo_id = Repo.one(query)
    IO.puts(Repo.aggregate(Todo, :count, :id))

    if Repo.aggregate(Todo, :count, :id) >= 1 do
      todoToUpdate = get_task!(todo_id)
      change_task(todoToUpdate, %{"order" => id})
    end
  end

  def get_largest_task_order(list_id) do
    IO.inspect(list_id)
    if Repo.aggregate(Task, :count, :id) >= 1 do
      query =
        from t in Task,
          where: t.list_id == ^list_id,
          select: t.order,
          order_by: [desc: :order],
          limit: 1

      lastOrder = Repo.one(query)
      if lastOrder != nil do
        lastOrder = lastOrder + 1
      else
        1
      end
    else
      1
    end
  end

  def get_largest_list_order(user_id) do
    IO.inspect(user_id)
    if Repo.aggregate(Task, :count, :id) >= 1 do
      query =
        from l in "lists",
          order_by: [desc: :order],
          select: l.order,
          where: l.user_id == ^user_id,
          limit: 1

      lastOrder = Repo.one(query)
      # IO.puts(lastOrder)
      if lastOrder != nil do
        lastOrder = lastOrder + 1
      else
        1
      end
    else
      1
    end
  end

  def change_todo_order(id, newListOrder) do
    list_id = Repo.one!(
      from t in Task,
      where: t.id == ^id,
      select: t.list_id,
      limit: 1
    )

    IO.inspect(list_id)
    currentListOrder =
      Repo.one!(
        from t in "tasks",
          where: t.id == ^id and t.list_id == ^list_id,
          select: t.order,
          limit: 1
      )

    IO.inspect(currentListOrder)
    maxListOrder =
      Repo.one!(
        from t in "tasks",
          order_by: [desc: :order],
          where: t.list_id == ^list_id,
          select: t.order,
          limit: 1
      )

    cond do
      newListOrder > currentListOrder && maxListOrder >= newListOrder ->
        IO.puts("GOING UP!")

        from(t in Task,
          update: [set: [order: fragment("\"order\" - 1")]],
          where: t.order <= ^newListOrder and t.order > ^currentListOrder and t.list_id == ^list_id
        )
        |> Repo.update_all([])

        Repo.get_by(Task, id: id)
        |> change_task(%{order: newListOrder})
        |> Repo.update()

      newListOrder < currentListOrder && newListOrder >= 1 ->
        IO.puts("GOING DOWN!")

        from(t in Task,
          update: [set: [order: fragment("\"order\" + 1")]],
          where: t.order >= ^newListOrder and t.order < ^currentListOrder and t.list_id == ^list_id
        )
        |> Repo.update_all([])

        Repo.get_by(Task, id: id)
        |> change_task(%{order: newListOrder})
        |> Repo.update()

      true ->
        IO.puts("Nothing")
        :nil
    end

     # Repo.get_by(Task, id: id)
     # |> change_task(%{order: newListOrder})
     # |> Repo.update()
  end

  alias TodoApi.Todo.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  def get_all_todos() do
    users = Repo.all(
      from user in TodoApi.Todo.User,
      left_join: lists in assoc(user, :lists),
      left_join: tasks in assoc(lists, :tasks),
      preload: [lists: [tasks: [:comments]]]
    )
    {users}
  end

  def get_all_lists() do
    lists = Repo.all(
      from list in TodoApi.Todo.List,
      left_join: user in assoc(list, :user),
      left_join: tasks in assoc(list, :tasks),
      left_join: list_permissions in assoc(list, :list_permissions),
      left_join: comments in assoc(tasks, :comments),
      group_by: [list.id],
      preload:  [:user, :list_permissions, tasks: ^from(t in Task, left_join: user in assoc(t, :user), order_by: t.order, preload: [:comments, :user])]
    )
    {lists}
  end

  # def get_comments_from_task_id(id) do
  #   comments = Repo.all()
  # end

  alias TodoApi.Todo.ListPermission

  @doc """
  Returns the list of list_permissions.

  ## Examples

      iex> list_list_permissions()
      [%ListPermission{}, ...]

  """
  def list_list_permissions do
    Repo.all(ListPermission)
  end

  @doc """
  Gets a single list_permission.

  Raises `Ecto.NoResultsError` if the List permission does not exist.

  ## Examples

      iex> get_list_permission!(123)
      %ListPermission{}

      iex> get_list_permission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list_permission!(id), do: Repo.get!(ListPermission, id)

  @doc """
  Creates a list_permission.

  ## Examples

      iex> create_list_permission(%{field: value})
      {:ok, %ListPermission{}}

      iex> create_list_permission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list_permission(attrs \\ %{}) do
    IO.inspect(attrs)
    %ListPermission{}
    |> ListPermission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a list_permission.

  ## Examples

      iex> update_list_permission(list_permission, %{field: new_value})
      {:ok, %ListPermission{}}

      iex> update_list_permission(list_permission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list_permission(%ListPermission{} = list_permission, attrs) do
    list_permission
    |> ListPermission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a list_permission.

  ## Examples

      iex> delete_list_permission(list_permission)
      {:ok, %ListPermission{}}

      iex> delete_list_permission(list_permission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list_permission(%ListPermission{} = list_permission) do
    Repo.delete(list_permission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list_permission changes.

  ## Examples

      iex> change_list_permission(list_permission)
      %Ecto.Changeset{data: %ListPermission{}}

  """
  def change_list_permission(%ListPermission{} = list_permission, attrs \\ %{}) do
    ListPermission.changeset(list_permission, attrs)
  end

  alias TodoApi.Todo.TaskPermission

  @doc """
  Returns the list of task_permissions.

  ## Examples

      iex> list_task_permissions()
      [%TaskPermission{}, ...]

  """
  def list_task_permissions do
    Repo.all(TaskPermission)
  end

  @doc """
  Gets a single task_permission.

  Raises `Ecto.NoResultsError` if the Task permission does not exist.

  ## Examples

      iex> get_task_permission!(123)
      %TaskPermission{}

      iex> get_task_permission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task_permission!(id), do: Repo.get!(TaskPermission, id)

  @doc """
  Creates a task_permission.

  ## Examples

      iex> create_task_permission(%{field: value})
      {:ok, %TaskPermission{}}

      iex> create_task_permission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task_permission(attrs \\ %{}) do
    %TaskPermission{}
    |> TaskPermission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task_permission.

  ## Examples

      iex> update_task_permission(task_permission, %{field: new_value})
      {:ok, %TaskPermission{}}

      iex> update_task_permission(task_permission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task_permission(%TaskPermission{} = task_permission, attrs) do
    task_permission
    |> TaskPermission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task_permission.

  ## Examples

      iex> delete_task_permission(task_permission)
      {:ok, %TaskPermission{}}

      iex> delete_task_permission(task_permission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task_permission(%TaskPermission{} = task_permission) do
    Repo.delete(task_permission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task_permission changes.

  ## Examples

      iex> change_task_permission(task_permission)
      %Ecto.Changeset{data: %TaskPermission{}}

  """
  def change_task_permission(%TaskPermission{} = task_permission, attrs \\ %{}) do
    TaskPermission.changeset(task_permission, attrs)
  end


end
