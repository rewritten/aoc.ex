#! /usr/bin/env elixir

Mix.install([:complex])

defmodule Submarine do
  use GenServer

  import Complex

  defstruct loc: %Complex{}, aim: %Complex{re: 1}

  def new(opts \\ []), do: GenServer.start_link(__MODULE__, :ok, opts)

  def command(pid, cmd, <<"up ", n::binary>>),
    do: GenServer.cast(pid, {cmd, %Complex{im: -String.to_integer(n)}})

  def command(pid, cmd, <<"down ", n::binary>>),
    do: GenServer.cast(pid, {cmd, %Complex{im: String.to_integer(n)}})

  def command(pid, _, <<"forward ", n::binary>>),
    do: GenServer.cast(pid, {:forward, String.to_integer(n)})

  @impl true
  def init(_), do: {:ok, %__MODULE__{}}

  @impl true
  def handle_cast({:move, n}, s), do: {:noreply, update_in(s.loc, &add(&1, n))}
  def handle_cast({:aim, n}, s), do: {:noreply, update_in(s.aim, &add(&1, n))}
  def handle_cast({:forward, n}, s), do: {:noreply, update_in(s.loc, &add(&1, mult(s.aim, n)))}

  @impl true
  def handle_call(:result, _, state), do: {:reply, state.loc.im * state.loc.re, state}
end

{:ok, simple_submarine} = Submarine.new()
{:ok, aiming_submarine} = Submarine.new()

for line <- File.stream!("2021/2.txt") do
  Submarine.command(simple_submarine, :move, String.trim(line))
  Submarine.command(aiming_submarine, :aim, String.trim(line))
end

simple_submarine
|> GenServer.call(:result)
|> IO.inspect(label: "part 1")

aiming_submarine
|> GenServer.call(:result)
|> IO.inspect(label: "part 2")
