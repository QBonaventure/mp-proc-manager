defmodule MPProcManager.Application do
  use Application


  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: MPProcManager.ManiaplanetServerSupervisor}
    ]
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
    |> IO.inspect 
  end

end
