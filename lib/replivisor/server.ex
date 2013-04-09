defmodule Replivisor.Server do
	use GenServer.Behaviour

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
		#ChangesOptions = [continuous, heartbeat, SinceTuple],
		#ServerPid = whereis(?MODULE),
		#{ok, _StartRef, _ChangePid} = couchbeam_changes:stream(Db, ServerPid, ChangesOptions).
	end

end