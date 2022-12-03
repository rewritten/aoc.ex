defmodule Aoc.Opcode do
  use GenServer

  defstruct pos: 0, state: :idle, input: [], output: []

  import Process, only: [put: 2, get: 1, get: 2]

  @position 0
  @immediate 1
  @relative 2

  @add 1
  @mul 2
  @input 3
  @output 4
  @jump_if_true 5
  @jump_if_false 6
  @less_than 7
  @equals 8
  @rebase 9
  @stop 99

  def start(input, initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, {input, initial_state})
  end

  @impl true
  def init({data, state}) do
    for {item, idx} <- Enum.with_index(data), do: put(idx, item)
    {:ok, struct!(__MODULE__, state)}
  end

  def run(pid), do: GenServer.cast(pid, :run)

  def inspect(pid), do: GenServer.call(pid, :inspect)

  def at_zero(pid), do: GenServer.call(pid, :at_zero)

  def diagnostic(pid), do: GenServer.call(pid, :diagnostic)

  def input(pid, n), do: GenServer.cast(pid, {:input, n})

  @impl true
  def handle_call(:at_zero, _from, state) do
    {:reply, get(0), state}
  end

  def handle_call(:inspect, _from, state) do
    memory =
      0
      |> Stream.iterate(&(&1 + 1))
      |> Stream.map(&get/1)
      |> Stream.take_while(&(!is_nil(&1)))
      |> Enum.to_list()

    {:reply, [memory: memory, state: state], state}
  end

  def handle_call(:diagnostic, _from, state) do
    {:reply, hd(state.output), state}
  end

  @impl true
  def handle_cast(:run, state) do
    {:noreply, %{state | state: :running}, {:continue, :run}}
  end

  def handle_cast({:input, n}, state) do
    {:noreply, %{state | state: :running, input: state.input ++ [n]}, {:continue, :run}}
  end

  @impl true
  def handle_continue(:run, %{pos: pos} = state) do
    val = get(pos)
    pointer = rem(val, 100)
    mode = val |> div(100) |> Integer.digits() |> Enum.reverse()
    op(pointer, state, mode)
  end

  def handle_continue({:move, n}, state),
    do: {:noreply, %{state | pos: state.pos + n}, {:continue, :run}}

  def handle_continue({:jump, n}, state),
    do: {:noreply, %{state | pos: n}, {:continue, :run}}

  def op(@stop, state, _) do
    {:noreply, %{state | state: :terminated}}
  end

  def op(@add, state, modes) do
    [a, b, c] = read(3, state.pos + 1, modes)
    put(c, get(a) + get(b))
    {:noreply, state, {:continue, {:move, 4}}}
  end

  def op(@mul, state, modes) do
    [a, b, c] = read(3, state.pos + 1, modes)
    put(c, get(a) * get(b))
    {:noreply, state, {:continue, {:move, 4}}}
  end

  def op(@input, %{input: [val | rest]} = state, modes) do
    [a] = read(1, state.pos + 1, modes)
    put(a, val)
    {:noreply, %{state | input: rest}, {:continue, {:move, 2}}}
  end

  def op(@input, %{input: []} = state, _) do
    {:noreply, %{state | state: :awaiting_input}}
  end

  def op(@output, state, modes) do
    [a] = read(1, state.pos + 1, modes)
    {:noreply, %{state | output: [get(a) | state.output]}, {:continue, {:move, 2}}}
  end

  def op(@jump_if_true, state, modes) do
    [a, b] = read(2, state.pos + 1, modes)
    {:noreply, state, {:continue, if(get(a) != 0, do: {:jump, get(b)}, else: {:move, 3})}}
  end

  def op(@jump_if_false, state, modes) do
    [a, b] = read(2, state.pos + 1, modes)
    {:noreply, state, {:continue, if(get(a) == 0, do: {:jump, get(b)}, else: {:move, 3})}}
  end

  def op(@less_than, state, modes) do
    [a, b, c] = read(3, state.pos + 1, modes)
    put(c, if(get(a) < get(b), do: 1, else: 0))
    {:noreply, state, {:continue, {:move, 4}}}
  end

  def op(@equals, state, modes) do
    [a, b, c] = read(3, state.pos + 1, modes)
    put(c, if(get(a) == get(b), do: 1, else: 0))
    {:noreply, state, {:continue, {:move, 4}}}
  end

  def op(@rebase, state, modes) do
    [a] = read(1, state.pos + 1, modes)
    put(:base, get(:base, 0) + get(a, 0))
    {:noreply, state, {:continue, {:move, 2}}}
  end

  def read(0, _, _), do: []
  def read(amt, pos, []), do: [get(pos, 0) | read(amt - 1, pos + 1, [])]
  def read(amt, pos, [@position | rest]), do: [get(pos, 0) | read(amt - 1, pos + 1, rest)]
  def read(amt, pos, [@immediate | rest]), do: [pos | read(amt - 1, pos + 1, rest)]

  def read(amt, pos, [@relative | rest]),
    do: [get(:base, 0) + get(pos, 0) | read(amt - 1, pos + 1, rest)]
end
