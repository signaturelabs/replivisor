defmodule Replivisor.Server do
	use GenServer.Behaviour
	alias Replivisor.Config, as: Config
	alias Replivisor.Change, as: Change
	alias Replivisor.Change.ChangeEntry, as: ChangeEntry

	def start_link do
		:gen_server.start_link({:local, __MODULE__}, __MODULE__, HashDict.new, [])	
	end

	def init(_statehash) do

		# get the list of dbs we need to monitor from config
		couchdbs = Config.databases		

		# loop over each one and start monitoring
		server_pid = :erlang.whereis(__MODULE__)
		statehash = Replivisor.Couchbeam.monitor_couchdb_list(server_pid, couchdbs)

		{ :ok, statehash }
	end

	def handle_info(msg, statehash) do

		{:change, ref, raw_change} = msg
		couchdb = HashDict.get(statehash, ref)
		change_entry = Change.create_change_entry(raw_change)

		spawn fn ->
		       Replivisor.Changehandler.handle_change(couchdb, change_entry)		      
	        end

		{ :noreply, statehash }
	end


end