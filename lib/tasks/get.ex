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

    {text, title, module_name} = get_text(year, day)
    save_text(year, title, text)
    create_code(year, title, module_name)
    create_test(year, day, title, module_name)
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

    {:ok, problem_markdown} = Pandex.html_to_gfm(problem_html, ~w[--backtick_code_blocks])

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

    # [problem_markdown, _] = String.split(problem_markdown, "Both parts of this puzzle")
    problem_markdown = String.trim(problem_markdown)
    [_, title | _] = String.split(problem_markdown, "---")
    title = String.trim(title)

    module_name =
      title
      |> String.split(":")
      |> Enum.at(1)
      |> String.downcase()
      |> String.replace(~w[' ? ! ,], "")
      |> String.replace(~r{[ -]}, "_")
      |> Macro.camelize()

    {problem_markdown, title, module_name}
  end

  def save_text(year, title, text) do
    text =
      text
      |> String.replace(~r[## --- (Day (\d+)): (.+) ---\n], """
      # \\1: \\3

      ```elixir
      text = File.read!("input/2022/\\2.txt")
      ```

      ## \\3
      """)
      |> String.replace(~r[## --- Part Two ---\n], """
      ## Part Two
      """)

    File.write("text/#{year}/#{title}.livemd", text)
  end

  def create_code(year, title, module_name) do
    if File.exists?("lib/#{year}/#{title}.ex") do
      IO.puts("Code file already exists")
    else
      IO.puts("Creating code file...")

      File.write!("lib/#{year}/#{title}.ex", """
      defmodule Aoc.#{module_name} do
        def solve(1, text) do
        end

        def solve(2, text) do
        end
      end
      """)
    end
  end

  def create_test(year, day, title, module_name) do
    test_file_contents = File.read!("test/#{year}.exs")

    if String.contains?(test_file_contents, title) do
      IO.puts("Tests already exist")
    else
      IO.puts("Adding tests...")

      new_test = """

        describe "#{title}" do
          @describetag mod: Aoc.#{module_name}, input: File.read!("input/#{year}/#{day}.txt")

          test! part: 1, expected: 0
          test! part: 2, expected: 0
        end
      """

      new_test_file = Regex.replace(~r"(?=end\n\z)", test_file_contents, new_test)
      File.write!("test/#{year}.exs", new_test_file)
    end
  end

  defp get!(url) do
    HTTPoison.get!(
      "https://adventofcode.com/" <> url,
      [{"User-Agent", "github.com/rewritten/aoc.ex by saverio.trioni@gmail.com"}],
      hackney: [cookie: ["session=#{System.get_env("SESSION")}"]]
    ).body
  end
end
