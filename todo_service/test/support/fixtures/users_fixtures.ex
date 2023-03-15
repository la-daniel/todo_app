defmodule TodoApi.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoApi.Users` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        detail: "some detail",
        order: 42,
        title: "some title"
      })
      |> TodoApi.Users.create_todo()

    todo
  end
end
