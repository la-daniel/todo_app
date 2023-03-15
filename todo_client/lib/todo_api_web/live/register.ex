defmodule TodoApiWeb.Register do
  use TodoApiWeb, :live_view
  alias TodoApi.Todo.UserRegister
  require Phoenix.Component

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_credentials_changeset()}
  end

  def assign_credentials_changeset(socket) do
    assign(socket, %{creds_changeset: UserRegister.changeset(%UserRegister{}, %{}), trigger_submit: false})
  end

  def handle_event("validate_registration", %{"user_register" => params}, socket) do
    changeset =
      %UserRegister{}
      |> UserRegister.changeset(params)
      |> Map.put(:action, :insert)
    {:noreply, assign(socket, list_changeset: changeset)}
  end

  def handle_event("register_creds", %{"user_register" => params}, socket) do
    IO.inspect(params)
    changeset = UserRegister.changeset(%UserRegister{}, params)
    if UserRegister.changeset(%UserRegister{}, params).valid? do
      socket = assign(socket, creds_changeset: changeset, trigger_submit: true)
      {:noreply, socket}
    else
      {:noreply, assign(socket, :creds_changeset, changeset)}
    end
  end
end
