defmodule TodoApiWeb.SessionController do
  use TodoApiWeb, :controller
  use Tesla
  require Logger
  # plug Tesla.Middleware.BaseUrl, "http://172.21.0.3:4001"
  Tesla.Builder.plug(Tesla.Middleware.BaseUrl, "http://172.21.0.3:4001/api")
  Tesla.Builder.plug(Tesla.Middleware.JSON)
  Tesla.Builder.plug(Tesla.Middleware.FormUrlencoded)

  defp secret, do: TodoApiWeb.Endpoint.config(:secret_key_base)
 
  def logout(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: "/login")
  end

  def login(conn, user) do
    # IO.inspect(conn)
    IO.inspect(user)
    user_encrypt_password = update_in(user, ["user", "password"], fn pass -> Plug.Crypto.encrypt(secret(), "password", pass) end)
    # user_test = Map.update!(user, "user", fn pass -> Plug.Crypto.encrypt(secret(), "password", pass) end)
    # Plug.Crypto.encrypt(secret(), to_string(context), term)
    IO.puts("USER TESTTTTTTTTTTTTTTTT")
    IO.inspect(user_encrypt_password)
    # response = post("/session/", %{"user" => %{"email" => "test@example.com", "password" => "secret1234"}})
    case post("/session/", user_encrypt_password) do
     {:error, error} ->
        IO.inspect(error)
        redirect(conn, to: "/login")
     {:ok, response} ->
      IO.inspect(response)
      status = response.status
      case status do
        200 ->
          body = response.body
          data = body["data"]
          token = data["access_token"]
          renew_token = data["renewal_token"]
          current_user = data["current_user"]

          conn
          |> put_session("token", token)
          |> put_session("renew_token", renew_token)
          |> put_session("current_user", current_user)
          |> redirect( to: "/")
          |> halt()
        401 ->
            IO.inspect("ITS A FUCKING 401!")
            IO.inspect(conn.request_path)
           conn
           |> redirect(to: "/login")
           |> halt()
      end
    end
    conn
    |> redirect( to: "/login")
    |> halt()
  end

  def register(conn, user) do

    case post("/registration/", user) do
     {:error, error} ->
        IO.inspect("Registration Failed! See error below:")
        IO.inspect(error)
        redirect(conn, to: "/registration")
     {:ok, response} ->
      IO.inspect(response)
      status = response.status
      if status == 200 do
        conn
        |> redirect( to: "/login")
        |> halt()
      else
        IO.inspect("Registration Failed with OK response?!")
        IO.inspect(conn.request_path)
        conn
        |> redirect(to: "/registration")
        |> halt()
      end
    end

  end
end
