defmodule TodoApiWeb.TaskPermissionControllerTest do
  use TodoApiWeb.ConnCase

  import TodoApi.TodoFixtures

  alias TodoApi.Todo.TaskPermission

  @create_attrs %{
    read: true,
    write: true
  }
  @update_attrs %{
    read: false,
    write: false
  }
  @invalid_attrs %{read: nil, write: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all task_permissions", %{conn: conn} do
      conn = get(conn, Routes.task_permission_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create task_permission" do
    test "renders task_permission when data is valid", %{conn: conn} do
      conn = post(conn, Routes.task_permission_path(conn, :create), task_permission: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.task_permission_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "read" => true,
               "write" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.task_permission_path(conn, :create), task_permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task_permission" do
    setup [:create_task_permission]

    test "renders task_permission when data is valid", %{conn: conn, task_permission: %TaskPermission{id: id} = task_permission} do
      conn = put(conn, Routes.task_permission_path(conn, :update, task_permission), task_permission: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.task_permission_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "read" => false,
               "write" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, task_permission: task_permission} do
      conn = put(conn, Routes.task_permission_path(conn, :update, task_permission), task_permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task_permission" do
    setup [:create_task_permission]

    test "deletes chosen task_permission", %{conn: conn, task_permission: task_permission} do
      conn = delete(conn, Routes.task_permission_path(conn, :delete, task_permission))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.task_permission_path(conn, :show, task_permission))
      end
    end
  end

  defp create_task_permission(_) do
    task_permission = task_permission_fixture()
    %{task_permission: task_permission}
  end
end
