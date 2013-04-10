defmodule Replivisor.Config do

	defrecord CouchDB, source_url: nil, 
		           source_port: nil, 
		           source_dbname: nil,
		           target_url: nil, 
		           target_port: nil, 
		           target_dbname: nil, 
		           couchbeam_server: nil, 
                           couchbeam_db: nil, 
                           couchbeam_changes_ref: nil, 
		           couchbeam_change_pid: nil

	def databases do

		{:ok, filedata} = File.read("config.json")
		json = :jiffy.decode(filedata)
		
		couchdbs = []
		f = fn json_elt, couchdbs ->
		        couchdb = CouchDB.new()
		        {inner_elt} = json_elt  # unwrap from tuple - why is this even needed?
		        source_url = :proplists.get_value "source_url", inner_elt
		        couchdb = couchdb.source_url(source_url)
		        source_port = :proplists.get_value "source_port", inner_elt
		        couchdb = couchdb.source_port(source_port)
		        source_dbname = :proplists.get_value "source_dbname", inner_elt
		        couchdb = couchdb.source_dbname(source_dbname)
		        target_url = :proplists.get_value "target_url", inner_elt
		        couchdb = couchdb.target_url(target_url)
		        target_port = :proplists.get_value "target_port", inner_elt
		        couchdb = couchdb.target_port(target_port)
		        target_dbname = :proplists.get_value "target_dbname", inner_elt
		        couchdb = couchdb.target_dbname(target_dbname)
		        couchdbs = [couchdb | couchdbs]
		        {json_elt, couchdbs}
	        end
		{_, couchdbs} = Enum.map_reduce json, couchdbs, f
		couchdbs

	end

end