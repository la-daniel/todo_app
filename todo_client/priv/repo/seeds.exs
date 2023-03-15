# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TodoApi.Repo.insert!(%TodoApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

TodoApi.Repo.insert!(%TodoApi.Users.Todo{
  detail: "Test 1",
  order: 1,
  title: "Test Title 1"
})

TodoApi.Repo.insert!(%TodoApi.Users.Todo{
  detail: "Test 2",
  order: 2,
  title: "Test Title 2"
})

TodoApi.Repo.insert!(%TodoApi.Users.Todo{
  detail: "Test 3",
  order: 3,
  title: "Test Title 3"
})

TodoApi.Repo.insert!(%TodoApi.Users.Todo{
  detail: "Test 4",
  order: 4,
  title: "Test Title 4"
})

TodoApi.Repo.insert!(%TodoApi.Users.Todo{
  detail: "Test 5",
  order: 5,
  title: "Test Title 5"
})
