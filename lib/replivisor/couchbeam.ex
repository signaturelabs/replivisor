defmodule Replivisor.Couchbeam do

	def monitor_couchdb_list(server_pid, couchdbs) do
		Enum.each couchdbs, fn(couchdb) -> monitor_couchdb(server_pid, couchdb) end
	end

	def monitor_couchdb(server_pid, couchdb) do
		IO.puts "monitor: #{inspect(server_pid)} #{inspect(couchdb)}"
		couchdb = init_db(couchdb)
		couchdb = init_track_changes(server_pid, couchdb)
		
	end

	def init_db(couchdb) do
		options = []
		server = :couchbeam.server_connection(couchdb.url, couchdb.port, "", options)
		couchdb = couchdb.couchbeam_server(server)
		db_options = []
		{:ok, db} = :couchbeam.open_db(server, couchdb.dbname, db_options)
		couchdb = couchdb.couchbeam_db(db)
		couchdb
	end

	def init_track_changes(server_pid, couchdb) do
		{:ok, last_seq, _rows} = :couchbeam_changes.fetch(couchdb.couchbeam_db, [])
		since_tuple = {:since,last_seq}
		IO.puts "monitoring changes starting at seq: #{last_seq}"
		changes_options = [:continuous, :heartbeat, since_tuple]
		{:ok, start_ref, change_pid} = :couchbeam_changes.stream(couchdb.couchbeam_db, server_pid, changes_options)
		IO.puts "start_ref: #{inspect(start_ref)} change_pid: #{inspect(change_pid)}"
		couchdb = couchdb.couchbeam_changes_ref(start_ref)
		couchdb = couchdb.couchbeam_change_pid(change_pid)
		couchdb
	end



end