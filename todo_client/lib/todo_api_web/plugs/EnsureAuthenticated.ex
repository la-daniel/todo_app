defmodule TodoApiWeb.Plug.EnsureAuthenticated do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]
  use Tesla
  require Logger
  # plug Tesla.Middleware.BaseUrl, "http://172.20.0.3:4001"
  Tesla.Builder.plug(Tesla.Middleware.BaseUrl, "http://localhost:4001/api")
  Tesla.Builder.plug(Tesla.Middleware.JSON)
  Tesla.Builder.plug(Tesla.Middleware.FormUrlencoded)

  def init(options), do: options

  def call(conn, _opts) do
    # IO.puts("""
    # Verb: #{inspect(conn.method)}
    # Host: #{inspect(conn.host)}
    # Headers: #{inspect(conn.req_headers)}
    # """)
    #
    token = get_session(conn, :token)
    # renew token
    Logger.debug(conn)
    if token == nil do
      conn
      |> redirect(to: "/login")
      |> halt()
    # else
    #   IO.inspect(get_session(conn, "renew_token"))
    #
    #   case post("/session/renew", get_session(conn, "renew_token")) do
    #     {:error, error} ->
    #       IO.inspect(error)
    #       redirect(conn, to: "/login")
    #
    #     {:ok, response} ->
    #       IO.inspect(response)
    #       status = response.status
    #
    #       case status do
    #         200 ->
    #           body = response.body
    #           data = body["data"]
    #           token = data["access_token"]
    #           renew_token = data["renewal_token"]
    #
    #           conn
    #           |> put_session("token", token)
    #           |> put_session("renew_token", renew_token)
    #           |> redirect(to: "/")
    #           |> halt()
    #
    #         401 ->
    #           conn
    #           |> redirect(to: "/login")
    #           |> halt()
    #       end
    #   end
    end

    conn
  end
end
