defmodule Replivisor.Server do
	use GenServer.Behaviour
	alias Replivisor.Config, as: Config

	def start_link do
		:gen_server.start_link({:local, __MODULE__}, __MODULE__, HashDict.new, [])	
	end

	def init(statehash) do

		# get the list of dbs we need to monitor from config
		couchdbs = Config.databases		

		# loop over each one and start monitoring
		server_pid = :erlang.whereis(__MODULE__)
		statehash = Replivisor.Couchbeam.monitor_couchdb_list(server_pid, couchdbs)

		{ :ok, statehash }
	end

	def handle_info(msg, state) do
		# example msg
		# {:change,#Reference<0.0.0.535>,
		# {[{"seq",13182},{"id","00175475-1292-419A-B0C6-B1D457F29528"},{"changes",[{[{"rev","8-2eb257db8a15ada29cfda2eabe3b695d"}]}]}]}}
		IO.puts "handle_info called with: #{inspect(msg)}"
		{ :noreply, state }
	end


end