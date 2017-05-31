defmodule TestSwarm.Supervisor do
  use Supervisor
  require Logger

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(TestSwarm.Worker, [],  restart: :temporary),
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def start_worker(uuid) do
    Logger.debug(fn -> "Starting worker for uuid: #{inspect uuid}" end)
    case Supervisor.start_child(__MODULE__, [uuid]) do
      {:ok, _pid} -> {:ok, uuid}
      {:error, {:already_started, _pid}} -> {:ok, uuid}
      other -> {:error, other}
    end
  end
end
