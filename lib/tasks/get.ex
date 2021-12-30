defmodule Mix.Tasks.Get do
  @moduledoc "Printed when the user requests `mix help echo`"
  @shortdoc "Echoes arguments"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    HTTPoison.start()

    session = System.get_env("SESSION")

    [year, day] =
      args
      |> Enum.map(&String.to_integer/1)
      |> case do
        [y, d] -> [y, d]
        [d] -> [2021, d]
      end

    if File.exists?("input/#{year}/#{day}.txt") do
      IO.puts("Already exists")
    else
      IO.puts("Downloading...")

      "https://adventofcode.com/#{year}/day/#{day}/input"
      |> HTTPoison.get!([], hackney: [cookie: ["session=#{session}"]])
      |> then(&File.write("input/#{year}/#{day}.txt", &1.body))
    end

    Mix.shell().info(Enum.join(args, " "))
  end
end
