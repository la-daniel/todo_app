defmodule TodoApiWeb.API.TaskView do
  use TodoApiWeb, :view
  alias TodoApiWeb.API.TaskView

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{
      id: task.id,
      detail: task.detail,
      title: task.title,
      order: task.order,
      user_id: task.user_id
    }
  end
end
