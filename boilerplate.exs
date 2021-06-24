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

    Mix.Tasks.Phx.Gen.Secret.run([])

    IO.puts("--> Generating signing salt...")

    Mix.Tasks.Phx.Gen.Secret.run(["32"])

    IO.puts("--> Edit your config.exs with these values.")
    IO.puts("--> Optionally delete this file as well.")
  end

  def process_file(file, %{:module_name => module_name, :otp_name => otp_name}) do
    replaced_content =
      File.read!(file)
      |> String.replace("UseIndie", module_name, global: true)
      |> String.replace("useindie", otp_name, global: true)

    File.write(file, replaced_content)
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
