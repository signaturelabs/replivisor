defmodule Replivisor.Couchbeam do

	def monitor_couchdb_list(server_pid, couchdbs) do
		couchdbs_hash = HashDict.new
		f = fn couchdb, couchdbs_hash ->
		        couchdb = monitor_couchdb(server_pid, couchdb)
		        key = couchdb.couchbeam_changes_ref
		        couchdbs_hash = HashDict.put(couchdbs_hash, key, couchdb)
		        {couchdb, couchdbs_hash}
	        end
		{_, couchdbs_hash} = Enum.map_reduce couchdbs, couchdbs_hash, f
		couchdbs_hash
	end

	def monitor_couchdb(server_pid, couchdb) do
		IO.puts "monitor: #{inspect(server_pid)} #{inspect(couchdb)}"
		couchdb = init_source_db(couchdb)
		couchdb = init_track_changes(server_pid, couchdb)
		couchdb
	end

	def init_source_db(couchdb) do
		{server, db} = init_db(couchdb.source_url, 
                                       couchdb.source_port, 
                                       couchdb.source_dbname,
                                       couchdb.source_username,
                                       couchdb.source_password)
		couchdb = couchdb.couchbeam_server(server)
		couchdb = couchdb.couchbeam_db(db)
		couchdb
	end

	def init_db(db_url, db_port, dbname, username, password) do
		options = if username, do: [{:basic_auth, {username, password}}], else: []
		server = :couchbeam.server_connection(db_url, db_port, "", options)
		db_options = []
		{:ok, db} = :couchbeam.open_db(server, dbname, db_options)
		{server, db}
	end

	def init_track_changes(server_pid, couchdb) do
		{:ok, last_seq, _rows} = :couchbeam_changes.fetch(couchdb.couchbeam_db, [])
		since_tuple = {:since,last_seq}
		IO.puts "monitoring changes starting at seq: #{last_seq}"
		changes_options = [:continuous, :heartbeat, since_tuple]
		{:ok, start_ref, change_pid} = :couchbeam_changes.stream(couchdb.couchbeam_db, server_pid, changes_options)
		couchdb = couchdb.couchbeam_changes_ref(start_ref)
		couchdb = couchdb.couchbeam_change_pid(change_pid)
		couchdb
	end

	def lookup_revision_from_docid(db, doc_id) do
		lookup_field_from_docid(db, "_rev", doc_id)
	end

	def lookup_field_from_docid(db, fieldname, doc_id) do
		doc_lookup_result = :couchbeam.open_doc(db, doc_id)
		case doc_lookup_result do 
			{:ok, doc} ->
			        :couchbeam_doc.get_value(fieldname, doc)
                        {:error, _} ->
			        IO.puts "doc lookup failed for #{doc_id}"
			        nil
		end
	end


end