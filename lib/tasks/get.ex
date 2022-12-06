defmodule Mix.Tasks.Get do
  @moduledoc "Gets input, text and other stuff from a specifc day"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    HTTPoison.start()

    [year, day] =
      args
      |> Enum.map(&String.to_integer/1)
      |> case do
        [y, d] -> [y, d]
        [d] -> [2021, d]
      end

    get_input(year, day)

    text = get_text(year, day)
    save_text(year, text)
  end

  def get_input(year, day) do
    if File.exists?("input/#{year}/#{day}.txt") do
      IO.puts("Input file already exists")
    else
      IO.puts("Downloading input file...")

      input = get!("#{year}/day/#{day}/input")
      File.write("input/#{year}/#{day}.txt", input)
    end
  end

  def get_text(year, day) do
    problem_html = get!("#{year}/day/#{day}")

    {:ok, problem_markdown} = Pandex.html_to_gfm(problem_html)

    [_, problem_markdown] = String.split(problem_markdown, "<div role=\"main\">")

    [problem_markdown, _] =
      cond do
        String.contains?(problem_markdown, "Both parts of this puzzle") ->
          String.split(problem_markdown, "Both parts of this puzzle")

        String.contains?(problem_markdown, "Answer") ->
          String.split(problem_markdown, "Answer")

        true ->
          String.split(problem_markdown, "To begin, ")
      end

    String.trim(problem_markdown)
  end

  def save_text(year, text) do
    title = text |> String.split("---", parts: 3) |> Enum.at(1) |> String.trim()

    text =
      text
      |> String.replace(~r[## --- (Day (\d+)): (.+) ---\n], """
      # \\1: \\3

      ```elixir
      text = File.read!("input/#{year}/\\2.txt")
      ```

      ## \\3
      """)
      |> String.replace(~r[## --- Part Two ---\n], """
      ```elixir
      ```

      ## Part Two
      """)
      |> Kernel.<>("""

      ```elixir
      ```
      """)

    File.mkdir_p!("#{year}")
    File.write("#{year}/#{title}.livemd", text)
  end

  defp get!(url) do
    HTTPoison.get!(
      "https://adventofcode.com/" <> url,
      [{"User-Agent", "github.com/rewritten/aoc.ex by saverio.trioni@gmail.com"}],
      hackney: [cookie: ["session=#{System.get_env("SESSION")}"]]
    ).body
  end
end
