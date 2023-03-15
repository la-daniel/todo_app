defmodule TodoApiWeb.ListPermissionControllerTest do
  use TodoApiWeb.ConnCase

  import TodoApi.TodoFixtures

  alias TodoApi.Todo.ListPermission

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
    test "lists all list_permissions", %{conn: conn} do
      conn = get(conn, Routes.list_permission_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create list_permission" do
    test "renders list_permission when data is valid", %{conn: conn} do
      conn = post(conn, Routes.list_permission_path(conn, :create), list_permission: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.list_permission_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "read" => true,
               "write" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.list_permission_path(conn, :create), list_permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update list_permission" do
    setup [:create_list_permission]

    test "renders list_permission when data is valid", %{conn: conn, list_permission: %ListPermission{id: id} = list_permission} do
      conn = put(conn, Routes.list_permission_path(conn, :update, list_permission), list_permission: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.list_permission_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "read" => false,
               "write" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, list_permission: list_permission} do
      conn = put(conn, Routes.list_permission_path(conn, :update, list_permission), list_permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete list_permission" do
    setup [:create_list_permission]

    test "deletes chosen list_permission", %{conn: conn, list_permission: list_permission} do
      conn = delete(conn, Routes.list_permission_path(conn, :delete, list_permission))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.list_permission_path(conn, :show, list_permission))
      end
    end
  end

  defp create_list_permission(_) do
    list_permission = list_permission_fixture()
    %{list_permission: list_permission}
  end
end
