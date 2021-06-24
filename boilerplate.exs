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

    rename_paths(files, %{module_name: module_name, otp_name: otp_name})

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

    IO.puts("writing #{file}")
    File.write!(file, replaced_content)
  end

  def rename_paths(files, %{:otp_name => otp_name}) do
    paths =
      files
      |> Enum.map(&Path.dirname/1)
      # Remove invalid paths
      |> Enum.filter(fn path -> path != "." end)
      |> Enum.uniq()
      # Sort by length, start with the root paths first
      |> Enum.sort_by(&String.length/1)

    Enum.each(paths, fn path ->
      IO.puts("renaming #{path}")
      new_path = String.replace(path, "boilername", otp_name, global: true)
      File.mkdir_p!(new_path)
      File.rename!(path, new_path)
    end)
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
