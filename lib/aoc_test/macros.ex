defmodule AocTest.Macros do
  defmacro test!(title, expected \\ nil) do
    [_, year, day, name, part] = Regex.run(~r"(\d{4}) - Day (\d{1,2}): (.*) \(part (\d)\)", title)
    name = name |> String.downcase() |> String.replace(" ", "_") |> Macro.camelize()
    mod = String.to_existing_atom("Elixir.Aoc." <> name)

    quote do
      test unquote(title), context do
        input = "input/#{unquote(year)}/#{unquote(day)}.txt" |> File.read!()
        data = unquote(mod).parse(input)
        result = apply(unquote(mod), :"part_#{unquote(part)}", [data])

        if unquote(expected) do
          # IO.inspect(result, label: context[:test])
          assert unquote(expected) == result
        else
          IO.inspect(result, label: context[:test])
        end
      end
    end
  end
end
