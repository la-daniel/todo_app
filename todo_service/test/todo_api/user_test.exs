defmodule TodoApi.UserTest do
  use TodoApi.DataCase

  alias TodoApi.User

  describe "todos" do
    alias TodoApi.User.Todo

    import TodoApi.UserFixtures

    @invalid_attrs %{details: nil, order: nil, title: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert User.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert User.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{details: "some details", order: 42, title: "some title"}

      assert {:ok, %Todo{} = todo} = User.create_todo(valid_attrs)
      assert todo.details == "some details"
      assert todo.order == 42
      assert todo.title == "some title"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = User.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{details: "some updated details", order: 43, title: "some updated title"}

      assert {:ok, %Todo{} = todo} = User.update_todo(todo, update_attrs)
      assert todo.details == "some updated details"
      assert todo.order == 43
      assert todo.title == "some updated title"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = User.update_todo(todo, @invalid_attrs)
      assert todo == User.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = User.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> User.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = User.change_todo(todo)
    end
  end
end
