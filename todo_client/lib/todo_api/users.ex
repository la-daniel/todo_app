defmodule TodoApi.Users do
  @moduledoc """
  The Users context.
  """
  # import Ecto.Changeset
  import Ecto.Query, warn: false
  alias TodoApi.Repo

  require Logger
  alias TodoApi.Todo.Task

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Task{}, ...]

  """
  def list_todos do
    Repo.all(
      from t in "todos",
        order_by: [asc: t.order],
        select: [:id, :detail, :title, :order]
    )
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Task{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Task{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    lastOrder =
      Repo.one(
        from t in "todos",
          order_by: [desc: t.order],
          select: [:order],
          limit: 1
      )

    nextOrder = if lastOrder !== nil, do: lastOrder.order + 1, else: 1
    attrs = Map.put(attrs, "order", nextOrder)

    %Task{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Task{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Task{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Task{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Task{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_todo(%Task{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end

  def set_last_nil_order_to_curr_id(id) do
    query =
      from t in "todos",
        where: is_nil(t.order),
        select: t.id

    todo_id = Repo.one(query)
    IO.puts(Repo.aggregate(Todo, :count, :id))

    if Repo.aggregate(Todo, :count, :id) >= 1 do
      todoToUpdate = get_todo!(todo_id)
      change_todo(todoToUpdate, %{"order" => id})
    end
  end

  def get_largest_order() do
    if Repo.aggregate(Todo, :count, :id) >= 1 do
      query =
        from t in "todos",
          order_by: [desc: :order],
          select: t.order,
          limit: 1

      lastOrder = Repo.one(query)
      # IO.puts(lastOrder)
      lastOrder + 1
    else
      1
    end
  end

  def change_todo_order(id, newListOrder) do
    currentListOrder =
      Repo.one!(
        from t in "todos",
          where: t.id == ^id,
          select: t.order,
          limit: 1
      )

    maxListOrder =
      Repo.one!(
        from t in "todos",
          order_by: [desc: :order],
          select: t.order,
          limit: 1
      )

    cond do
      newListOrder > currentListOrder && maxListOrder >= newListOrder ->
        IO.puts("GOING UP!")

        from(t in Todo,
          update: [set: [order: fragment("\"order\" - 1")]],
          where: t.order <= ^newListOrder and t.order > ^currentListOrder
        )
        |> Repo.update_all([])

        Repo.get_by(Todo, id: id)
        |> change_todo(%{order: newListOrder})
        |> Repo.update()

      newListOrder < currentListOrder && newListOrder >= 1 ->
        IO.puts("GOING DOWN!")

        from(t in Todo,
          update: [set: [order: fragment("\"order\" + 1")]],
          where: t.order >= ^newListOrder and t.order < ^currentListOrder
        )
        |> Repo.update_all([])

        Repo.get_by(Todo, id: id)
        |> change_todo(%{order: newListOrder})
        |> Repo.update()

      true ->
        IO.puts("Nothing")
    end

    # Repo.get_by(Todo, id: id)
    # |> change_todo(%{order: newListOrder})
    #  |> Repo.update()
  end
end
