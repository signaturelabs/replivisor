defmodule Replivisor do
	use Application.Behaviour
	
	def start(_type, args) do
    Replivisor.Supervisor.start_link(args)
	end

end
