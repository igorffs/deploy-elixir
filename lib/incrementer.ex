defmodule Incrementer do
  use GenServer

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
    IO.puts "#{total} + #{value} = #{new_total}"

    {:noreply, new_total}
  end

  def handle_call(:total, _from, total) do
    {:reply, total, total}
  end
end
