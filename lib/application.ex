defmodule TestSwarm.Application do
  use Application

  def start(_,_) do
    TestSwarm.Supervisor.start_link()
  end
end
