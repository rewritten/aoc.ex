defmodule AocTest.Macros do
  defmacro test!(opts) when is_list(opts) do
    part = Keyword.get(opts, :part)
    expected = Keyword.get(opts, :expected)

    quote do
      test "part #{unquote(part)}", %{input: input, mod: mod, test: test, describe: describe} do
        result = mod.solve(unquote(part), input)

        if unquote(expected) do
          # IO.inspect(result, label: context[:test])
          assert unquote(expected) == result
        else
          IO.inspect(result, label: test)
        end
      end
    end
  end
end
