defmodule TodoApi.UsersTest do
  use TodoApi.DataCase

  alias TodoApi.Users

  describe "todos" do
    alias TodoApi.Users.Todo

    import TodoApi.UsersFixtures

    @invalid_attrs %{detail: nil, order: nil, title: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Users.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Users.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{detail: "some detail", order: 42, title: "some title"}

      assert {:ok, %Todo{} = todo} = Users.create_todo(valid_attrs)
      assert todo.detail == "some detail"
      assert todo.order == 42
      assert todo.title == "some title"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{detail: "some updated detail", order: 43, title: "some updated title"}

      assert {:ok, %Todo{} = todo} = Users.update_todo(todo, update_attrs)
      assert todo.detail == "some updated detail"
      assert todo.order == 43
      assert todo.title == "some updated title"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_todo(todo, @invalid_attrs)
      assert todo == Users.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Users.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Users.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Users.change_todo(todo)
    end
  end
end
