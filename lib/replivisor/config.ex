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
		[ CouchDB.new(source_url: "localhost", 
                              source_port: 5984, 
                              source_dbname: "sigdb",
		              target_url: "localhost", 
                              target_port: 5984, 
                              target_dbname: "sigdb-copy"),  
		  CouchDB.new(source_url: "localhost", 
                              source_port: 5984, 
                              source_dbname: "sigdb-prod",
		              target_url: "localhost", 
                              target_port: 5984, 
                              target_dbname: "sigdb-prod-copy") ]
	end

end