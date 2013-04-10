defmodule Replivisor.Config do

	defrecord CouchDB, source_url: nil, 
		           source_port: nil, 
		           source_dbname: nil, 
		           couchbeam_server: nil, 
                           couchbeam_db: nil, 
                           couchbeam_changes_ref: nil, 
		           couchbeam_change_pid: nil

	def databases do
		[ CouchDB.new(source_url: "localhost", source_port: 5984, source_dbname: "sigdb"),  
		  CouchDB.new(source_url: "localhost", source_port: 5984, source_dbname: "sigdb-prod") ]
	end

end