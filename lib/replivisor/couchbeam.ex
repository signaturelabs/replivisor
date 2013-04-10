defmodule Replivisor.Couchbeam do

	def monitor_couchdb_list(server_pid, couchdbs) do
		couchdbs_hash = HashDict.new
		f = fn couchdb, couchdbs_hash ->
		        couchdb = monitor_couchdb(server_pid, couchdb)
		        key = couchdb.couchbeam_changes_ref
		        couchdbs_hash = HashDict.put(couchdbs_hash, key, couchdb)
		        {couchdb, couchdbs_hash}
	        end
		{couchdbs, couchdbs_hash} = Enum.map_reduce couchdbs, couchdbs_hash, f
		couchdbs_hash
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
	end

	def init_track_changes(server_pid, couchdb) do
		{:ok, last_seq, _rows} = :couchbeam_changes.fetch(couchdb.couchbeam_db, [])
		since_tuple = {:since,last_seq}
		IO.puts "monitoring changes starting at seq: #{last_seq}"
		changes_options = [:continuous, :heartbeat, since_tuple]
		{:ok, start_ref, change_pid} = :couchbeam_changes.stream(couchdb.couchbeam_db, server_pid, changes_options)
		couchdb = couchdb.couchbeam_changes_ref(start_ref)
		couchdb = couchdb.couchbeam_change_pid(change_pid)
	end

end