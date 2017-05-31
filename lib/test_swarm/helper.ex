defmodule TestSwarm.Helper do
  import ExUnit.Assertions

  def shutdown(pid) when is_pid(pid) do
    Process.unlink(pid)
    Process.exit(pid, :shutdown)

    ref = Process.monitor(pid)
    assert_receive {:DOWN, ^ref, _, _, _}, 5_000
  end

  def shutdown(aggregate_uuid) do
    #[{pid, _}] = Registry.lookup(:aggregate_registry, aggregate_uuid)
    pid = Swarm.whereis_name(aggregate_uuid)
    shutdown(pid)
  end


  def test() do
    uuid = "b78932b0-1265-4317-bd92-3a1a3c64789e"
    TestSwarm.Supervisor.start_worker(uuid)
    TestSwarm.Worker.worker_state(uuid)
    shutdown(uuid)
    TestSwarm.Supervisor.start_worker(uuid)
    TestSwarm.Worker.worker_state(uuid)
  end

end
