defmodule Replivisor.Config do

	defrecord CouchDB, url: nil, port: nil, dbname: nil, couchbeam_server: nil, 
                           couchbeam_db: nil, couchbeam_changes_ref: nil, couchbeam_change_pid: nil

	def databases do
		[ CouchDB.new(url: "localhost", port: 5984, dbname: "sigdb"),  
		  CouchDB.new(url: "localhost", port: 5984, dbname: "sigdb-prod") ]
	end

end