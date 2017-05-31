defmodule TestSwarm.Worker do
  use GenServer

  alias TestSwarm.Worker

  defstruct [
    uuid: nil,
    counter: 0,
  ]

  def start_link(uuid) do
    name = via_tuple(uuid)
    GenServer.start_link(__MODULE__, %Worker{uuid: uuid, counter: 1}, name: name)
  end

  defp via_tuple(uuid) do
    {:via, :swarm, uuid}
  end

  def init(%Worker{} = state) do
    Swarm.join(:workergroup, self())

    {:ok, state}
  end

  def worker_state(uuid) do
    GenServer.call(via_tuple(uuid), {:get_state})
  end

  def handle_call({:get_state}, _from, %Worker{} = state) do
    {:reply, state, state}
  end
end
