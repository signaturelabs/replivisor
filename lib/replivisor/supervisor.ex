defmodule Replivisor.Supervisor do
  use Supervisor.Behaviour

  # A convenience to start the supervisor
  def start_link(args) do
    :supervisor.start_link(__MODULE__, args)
  end

  # The callback invoked when the supervisor starts
  def init(args) do
    children = [ worker(Replivisor.Server, [args]) ]
    supervise children, strategy: :one_for_one
  end

end