defmodule BoilerName.Factory do
  use ExMachina.Ecto, repo: BoilerName.Repo

  def user_factory(attrs) do
    password = Map.get(attrs, :password, "password")

    user = %BoilerName.Auth.User{
      is_active: true,
      full_name: "Ya Boi Smith",
      username: sequence("user"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      hashed_password: Bcrypt.hash_pwd_salt(password)
    }

    merge_attributes(user, attrs)
  end
end
