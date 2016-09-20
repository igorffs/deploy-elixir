defmodule Incrementer do
  use GenServer

  @vsn "0.3.0"

  # State migration
  def code_change("0.2.0", total, _extra) do
    new_state = {:total, total}
    {:ok, new_state}
  end

  def code_change({:down, "0.3.0"}, total, _extra) do
    {:total, new_state} = total
    {:ok, new_state}
  end

  def run do
    {:ok, pid} = Incrementer.start_link(0)
    Incrementer.increment_for_life(pid)
  end

  def increment_for_life(pid) do
    Incrementer.increment_by(pid, 1)
    increment_for_life(pid)
  end

  def start_link(start_value) do
    GenServer.start_link(__MODULE__, {:total, start_value})
  end

  def increment_by(pid, value) do
    GenServer.cast(pid, {:increment, value})
  end

  def get_total(pid) do
    GenServer.call(pid, :total)
  end

  def handle_cast({:increment, value_to_incr}, total) do
    {:total, old_value} = total
    new_total = old_value + value_to_incr

    IO.puts "Incrementing ... #{old_value} + #{value_to_incr} = #{new_total}"

    :timer.sleep(5_000)
    {:noreply, {:total, new_total}}
  end

  def handle_call(:total, _from, total) do
    {:total, value} = total

    {:reply, value, total}
  end
end
