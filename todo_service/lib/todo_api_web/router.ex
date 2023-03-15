defmodule TodoApiWeb.Router do
  use TodoApiWeb, :router
  use Pow.Phoenix.Router
  
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TodoApiWeb.LayoutView, :root}
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  pipeline :api do
    plug :accepts, ["json"]
    plug TodoApiWeb.APIAuthPlug, otp_app: :todo_api
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: TodoApiWeb.APIAuthErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/api", TodoApiWeb.API, as: :api_v1 do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  scope "/api", TodoApiWeb.API, as: :api_v1 do
    pipe_through [:api, :api_protected]

    post "/change_order", TaskController, :change_order
    resources "/lists", ListController, except: [:new, :edit]
    resources "/tasks", TaskController, except: [:new, :edit]
    resources "/comments", CommentController, except: [:new, :edit]
    resources "/permissions", PermissionController, except: [:new, :edit]
    get "/get_all_todos", UserController, :get_all_todos
    get "/get_all_lists", ListController, :get_all_lists
    resources "/users", UserController, except: [:new, :edit]
    resources "/task_permissions", TaskPermissionController, except: [:new, :edit]
    resources "/list_permissions", ListPermissionController, except: [:new, :edit]
    # Your protected API endpoints here
  end

  scope "/", TodoApiWeb do
    pipe_through :browser
    # live "/", Todo
    # resources "/todos", TodoController, except: [:new, :edit]
    # post "/change_order", TaskController, :change_order
    # resources "/lists", ListController, except: [:new, :edit]
    # resources "/tasks", TaskController, except: [:new, :edit]
    # resources "/comments", CommentController, except: [:new, :edit]
    # resources "/permissions", PermissionController, except: [:new, :edit]
    # get "/get_all_todos", UserController, :get_all_todos
    # get "/get_all_lists", ListController, :get_all_lists
    # get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TodoApiWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TodoApiWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
