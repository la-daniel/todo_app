defmodule TodoApiWeb.Login do
  use TodoApiWeb, :live_view
  alias TodoApi.Todo.User
  require Phoenix.Component

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_credentials_changeset()}
  end

  def assign_credentials_changeset(socket) do
    assign(socket, %{creds_changeset: User.changeset(%User{}, %{}), trigger_submit: false})
  end

  def handle_event("validate_creds", %{"user" => params}, socket) do
    changeset =
      %User{}
      |> User.changeset(params)
      |> Map.put(:action, :insert)
    {:noreply, assign(socket, list_changeset: changeset)}
  end

  def handle_event("login_creds", %{"user" => params}, socket) do
    IO.inspect(params)
    changeset = User.changeset(%User{}, params)
    if User.changeset(%User{}, params).valid? do
      socket = assign(socket, creds_changeset: changeset, trigger_submit: true)
      {:noreply, socket}
    else
      {:noreply, assign(socket, :creds_changeset, changeset)}
    end
  end
end
