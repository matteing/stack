# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     UseIndie.Repo.insert!(%UseIndie.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
IO.puts("Creating the admin user...")
username = String.trim(IO.gets("Username: "))
email = String.trim(IO.gets("Email: "))
password = String.trim(IO.gets("Password: "))
repeat_password = String.trim(IO.gets("Repeat password: "))

if password != repeat_password do
  IO.puts("Incorrect password.")
  System.halt()
end

UseIndie.Auth.register_user!(%{
  username: username,
  email: email,
  password: password
})
