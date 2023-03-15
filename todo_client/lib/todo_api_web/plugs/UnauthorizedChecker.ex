defmodule Tesla.Middleware.UnauthorizedChecker do
  def call( env, next, socket) do
    env
    |> Tesla.run(next)
    |> checkFor401(socket)
  end

  def checkFor401( env, socket) do  
    {:ok, response} = env
    if response.status == 401 do
      IO.inspect("TIME TO RELOGIN")
      # REDIRECT TO LOGOUT HERE
      # IO.inspect(socket.assigns)
    else
      IO.inspect("ALL GOODS IN THE HOODS")
    end
    env
  end
end
