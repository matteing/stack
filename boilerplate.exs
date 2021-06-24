defmodule BoilerplateSetup do
  @folders ~w(lib test priv config)
  @extra_files ["./mix.exs", "coveralls.json"]
  @to_delete ["./lib/boilername", "./lib/boilername_web", "./boilerplate.exs"]

  def main() do
    IO.puts("--> Welcome to the boilerplate setup")
    files = List.flatten(Enum.map(@folders, &traverse_path/1)) ++ @extra_files
    module_name = String.trim(IO.gets("App name (e.g. BoilerName): "))
    otp_name = String.trim(IO.gets("OTP name, underscored (e.g. boilername): "))

    if module_name == "" or otp_name == "" do
      System.halt()
    end

    Enum.each(files, fn file ->
      process_file(file, %{module_name: module_name, otp_name: otp_name})
    end)

    IO.puts("--> Boilerplate generation complete.")
    IO.puts("--> Generating secret key...")

    secret_key = random_string(64)
    IO.puts(String.replace(secret_key, ~r/(?<=\A.).*(?=.\z)/, "***"))

    IO.puts("--> Generating signing salt...")

    signing_salt = random_string(32)
    IO.puts(String.replace(signing_salt, ~r/(?<=\A.).*(?=.\z)/, "***"))

    Enum.each(files, fn file ->
      process_file_secrets(file, %{secret_key: secret_key, signing_salt: signing_salt})
    end)

    IO.puts("--> Cleaning up...")
    cleanup()
  end

  def process_file(file, %{:module_name => module_name, :otp_name => otp_name}) do
    replaced_content =
      File.read!(file)
      |> String.replace("BoilerName", module_name, global: true)
      |> String.replace("boilername", otp_name, global: true)

    replaced_name =
      file
      |> String.replace("boilername", otp_name, global: true)

    File.write!(file, replaced_content)
    File.mkdir_p!(replaced_name |> Path.dirname())
    File.rename!(file, replaced_name)
  end

  def process_file_secrets(file, %{:secret_key => secret_key, :signing_salt => signing_salt}) do
    replaced_content =
      File.read!(file)
      |> String.replace("SECRET_FOR_DEV_GOES_HERE", secret_key, global: true)
      |> String.replace("SIGNING_SALT_GOES_HERE", signing_salt, global: true)

    File.write(file, replaced_content)
  end

  def cleanup() do
    Enum.each(@to_delete, &File.rm_rf!/1)
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
