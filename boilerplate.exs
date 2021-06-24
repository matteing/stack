defmodule BoilerplateSetup do
  @folders ~w(lib test priv config)

  def main() do
    IO.puts("--> Welcome to the boilerplate setup")
    files = List.flatten(Enum.map(@folders, &traverse_path/1))
    module_name = String.trim(IO.gets("App name (e.g. UseIndie): "))
    otp_name = String.trim(IO.gets("OTP name, underscored (e.g. useindie): "))

    if module_name == "" or otp_name == "" do
      System.halt()
    end

    Enum.each(files, fn file ->
      process_file(file, %{module_name: module_name, otp_name: otp_name})
    end)

    IO.puts("--> Boilerplate generation complete.")
    IO.puts("--> Generating secret key...")

    secret_key = random_string(64)
    IO.puts(secret_key)

    IO.puts("--> Generating signing salt...")

    signing_salt = random_string(32)
    IO.puts(signing_salt)

    Enum.each(files, fn file ->
      process_file_secrets(file, %{secret_key: secret_key, signing_salt: signing_salt})
    end)

    IO.puts("--> Optionally delete this file.")
  end

  def process_file(file, %{:module_name => module_name, :otp_name => otp_name}) do
    replaced_content =
      File.read!(file)
      |> String.replace("UseIndie", module_name, global: true)
      |> String.replace("useindie", otp_name, global: true)

    File.write(file, replaced_content)
  end

  def process_file_secrets(file, %{:secret_key => secret_key, :signing_salt => signing_salt}) do
    replaced_content =
      File.read!(file)
      |> String.replace("SECRET_FOR_DEV_GOES_HERE", secret_key, global: true)
      |> String.replace("SIGNING_SALT_GOES_HERE", signing_salt, global: true)

    File.write(file, replaced_content)
  end

  defp random_string(length) when length > 31 do
    :crypto.strong_rand_bytes(length) |> Base.encode64(padding: false) |> binary_part(0, length)
  end

  def traverse_path(path \\ ".") do
    cond do
      File.regular?(path) ->
        [path]

      File.dir?(path) ->
        File.ls!(path)
        |> Enum.map(&Path.join(path, &1))
        |> Enum.map(&traverse_path/1)
        |> Enum.concat()

      true ->
        []
    end
  end
end

BoilerplateSetup.main()
