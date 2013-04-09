defmodule Replivisor.Server do
	use GenServer.Behaviour

	def start_link do
		:gen_server.start_link({:local, __MODULE__}, __MODULE__, [], [])	
	end


	def init(state) do
		IO.puts "init called"
		db = init_db
		init_track_changes db
		{ :ok, state }
	end

	def handle_info(msg, state) do
		IO.puts "handle_info called"
		{ :noreply, state }
	end

	def init_db do
		options = []
		server = :couchbeam.server_connection "localhost", 5984, "", options 
		result = :couchbeam.server_info server
		db_options = []
		{ok, db} = :couchbeam.open_db server, "sigdb", db_options
		db
	end

	def init_track_changes(db) do
		{:ok, last_seq, _rows} = :couchbeam_changes.fetch(db, [])
		since_tuple = {:since,last_seq}
		IO.puts "monitoring changes starting at seq: #{last_seq}"
		changes_options = [:continuous, :heartbeat, since_tuple]
		server_pid = :erlang.whereis(__MODULE__)
		IO.puts "server_pid: #{inspect(server_pid)}"
		{:ok, _start_ref, _change_pid} = :couchbeam_changes.stream(db, server_pid, changes_options)
	end

end