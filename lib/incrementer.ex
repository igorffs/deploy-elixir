defmodule Incrementer do
  use GenServer

  def run do
    {:ok, pid} = Incrementer.start_link(0)
    Incrementer.increment_for_life(pid)
  end

  def increment_for_life(pid) do
    Incrementer.increment_by(pid, 1)
    increment_for_life(pid)
  end

  def start_link(start_value) do
    GenServer.start_link(__MODULE__, start_value)
  end

  def increment_by(pid, value) do
    GenServer.cast(pid, {:increment, value})
  end

  def get_total(pid) do
    GenServer.call(pid, :total)
  end

  def handle_cast({:increment, value}, total) do
    new_total = total + value
    IO.puts "Incrementing ... #{total} + #{value} = #{new_total}"

    :timer.sleep(5_000)
    {:noreply, new_total}
  end

  def handle_call(:total, _from, total) do
    {:reply, total, total}
  end
end
