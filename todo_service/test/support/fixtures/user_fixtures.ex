defmodule TodoApi.UserFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoApi.User` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        details: "some details",
        order: 42,
        title: "some title"
      })
      |> TodoApi.User.create_todo()

    todo
  end
end
