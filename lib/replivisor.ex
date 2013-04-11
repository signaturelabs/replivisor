defmodule Replivisor do
	use Application.Behaviour
	
	def start(_, _) do
		Replivisor.Server.start_link
	end

end
