#! /usr/bin/env elixir

data =
  for {line, i} <- "input/2021/11.txt" |> File.read!() |> String.split() |> Enum.with_index(),
      {c, j} <- line |> String.to_charlist() |> Enum.with_index(),
      into: %{},
      do: {{i, j}, c}

display = fn map ->
  for i <- 0..9 do
    IO.puts(for j <- 0..9, do: Map.get(map, {i, j}))
  end

  IO.puts("\n")
end

display_highlight = fn map, hl, done ->
  for i <- 0..9 do
    IO.puts(
      for j <- 0..9 do
        cond do
          {i, j} in hl -> ?☒
          {i, j} in done -> ?☐
          true -> Map.get(map, {i, j})
        end
      end
    )
  end

  IO.puts("\n")
end

loop =
  Stream.iterate(data, fn map ->
    # step 1: increase everthing by 1
    map = Map.map(map, fn {_, val} -> val + 1 end)
    # IO.puts("--- ENERGY IN!! ---")
    # display.(map)

    {map, []}
    |> Stream.unfold(fn {temp, flashed} ->
      # step 2: if a number is > 9 and has not already flashed, mark it as flashing
      to_flash = for {k, v} when v > ?9 <- temp, k not in flashed, do: k

      if !Enum.empty?(to_flash) do
        # display_highlight.(temp, to_flash, flashed)

        # step 3: increase neighbors of flashing numbers
        new_map =
          for {x, y} <- to_flash,
              i <- -1..1,
              j <- -1..1,
              {i, j} != {0, 0},
              (x + i) in 0..9,
              (y + j) in 0..9,
              z = {x + i, y + j},
              z not in flashed,
              reduce: temp do
            m -> Map.update!(m, z, &(&1 + 1))
          end

        {new_map, {new_map, to_flash ++ flashed}}
      end
    end)
    |> Enum.to_list()
    |> List.last()
    |> Kernel.||(map)
    # |> Enum.find_value(fn {m, _, complete} -> complete && m end)
    # |> tap(fn _ -> IO.puts("--- complete, about to exhaust ---") end)
    # |> tap(display)
    |> Map.map(fn {_, v} -> if v > ?9, do: ?0, else: v end)

    # |> tap(fn _ -> IO.puts("--- exhausted ---") end)
    # |> tap(display)
    # |> tap(fn _ -> IO.puts("--- ok ---") end)
  end)

# loop
# |> Enum.take(3)
# |> Enum.each(display)

loop
|> Stream.map(&Enum.count(&1, fn {_, v} -> v == ?0 end))
|> Stream.drop(1)
|> Stream.take(10)
|> Enum.sum()
|> IO.inspect(label: "part 1")
