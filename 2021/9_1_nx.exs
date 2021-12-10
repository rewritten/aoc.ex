#! /usr/bin/env elixir

Mix.install([{:nx, "~> 0.1.0-dev", github: "elixir-nx/nx", branch: "main", sparse: "nx"}])

t =
  "input/2021/9.txt"
  |> File.read!()
  |> String.split()
  |> Enum.join()
  |> Nx.from_binary({:s, 8})
  |> Nx.reshape({100, 100})
  |> Nx.pad(?9, [{1, 1, 0}, {1, 1, 0}])

for i <- 1..100,
    j <- 1..100,
    sub = t[[(i - 1)..(i + 1), (j - 1)..(j + 1)]],
    sub[1][1] < sub[0][1],
    sub[1][1] < sub[1][0],
    sub[1][1] < sub[2][1],
    sub[1][1] < sub[1][2] do
  Nx.to_number(sub[1][1]) - ?0 + 1
end
|> Enum.sum()
|> IO.inspect(label: "part 1")
