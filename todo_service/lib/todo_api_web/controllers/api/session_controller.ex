defmodule TodoApiWeb.API.SessionController do
  use TodoApiWeb, :controller

  alias TodoApiWeb.APIAuthPlug
  alias Plug.Conn
  alias TodoApi.Todo
  

  defp secret, do: TodoApiWeb.Endpoint.config(:secret_key_base)

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    
    user_decrypt_password = update_in(user_params, ["password"], 
    fn pass ->
        with  {:ok, decrypted_pass} <- Plug.Crypto.decrypt(secret(), "password", pass)  do
          IO.inspect(decrypted_pass)
          decrypted_pass
        end
     end)
    IO.inspect(user_decrypt_password)
    IO.puts("DECRYPT PASSWORDDDDDDDDDD")
    conn
    |> Pow.Plug.authenticate_user(user_decrypt_password)
    |> case do
      {:ok, conn} ->
        IO.inspect(user_decrypt_password)
        user = Todo.get_user_by_email(user_decrypt_password["email"])

        json(conn, %{
          data: %{
            access_token: conn.private.api_access_token,
            renewal_token: conn.private.api_renewal_token,
            current_user: %{email: Enum.at(user,0), id: Enum.at(user, 1)}
          }
        })

      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid email or password"}})
    end
  end

  @spec renew(Conn.t(), map()) :: Conn.t()
  def renew(conn, _params) do
    config = Pow.Plug.fetch_config(conn)

    conn
    |> APIAuthPlug.renew(config)
    |> case do
      {conn, nil} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid token"}})

      {conn, _user} ->

        json(conn, %{
          data: %{
            access_token: conn.private.api_access_token,
            renewal_token: conn.private.api_renewal_token
          }
        })
    end
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, _params) do
    conn
    |> Pow.Plug.delete()
    |> json(%{data: %{}})
  end
end
