defmodule MPProcManager.ManiaplanetServerSupervisor do
  use DynamicSupervisor
  alias DynamicSupervisorWithRegistry.Worker
  alias MPProcManager.ManiaplanetServer

  def start_link(_arg),
    do: DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_mp_server(%MPProcManager.ServerConfig{} = serv_conf) do
    mps_spec = MPProcManager.ManiaplanetServer.child_spec(serv_conf)

    DynamicSupervisor.start_child(__MODULE__, mps_spec)
  end


end
