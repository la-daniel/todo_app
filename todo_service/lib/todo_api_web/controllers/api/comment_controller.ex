defmodule TodoApiWeb.API.CommentController do
  use TodoApiWeb, :controller

  alias TodoApi.Todo
  alias TodoApi.Todo.Comment

  action_fallback TodoApiWeb.FallbackController

  def index(conn, _params) do
    comments = Todo.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Todo.create_comment(comment_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.comment_path(conn, :show, comment))
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Todo.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Todo.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Todo.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Todo.get_comment!(id)

    with {:ok, %Comment{}} <- Todo.delete_comment(comment) do
      render(conn, "show.json", comment: comment)
    end
  end
end
