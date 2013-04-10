defmodule Replivisor.Config do

	defrecord CouchDB, source_url: nil, 
		           source_port: nil, 
		           source_dbname: nil,
		           source_username: nil,
		           source_password: nil,
		           target_url: nil, 
		           target_port: nil, 
		           target_dbname: nil, 
                           target_username: nil,
                           target_password: nil,
		           couchbeam_server: nil, 
                           couchbeam_db: nil, 
                           couchbeam_changes_ref: nil, 
		           couchbeam_change_pid: nil

	def databases do

		{:ok, filedata} = File.read("config.json")
		json = :jiffy.decode(filedata)
		IO.puts "creating couchdbs config from json: #{inspect(json)}"
		couchdbs = []
		f = fn json_elt, couchdbs ->

                        # TODO: there has to be a more elegant way to do this.. 

		        couchdb = CouchDB.new()
		        {inner_elt} = json_elt  # unwrap from tuple - why is this even needed?
		        source_url = :proplists.get_value "source_url", inner_elt
		        couchdb = couchdb.source_url(source_url)
		        source_port = :proplists.get_value "source_port", inner_elt
		        couchdb = couchdb.source_port(source_port)
		        source_dbname = :proplists.get_value "source_dbname", inner_elt
		        couchdb = couchdb.source_dbname(source_dbname)

		        source_username = :proplists.get_value "source_username", inner_elt
		        if is_defined(source_username) do
				couchdb = couchdb.source_username(source_username)
		        end
			source_password = :proplists.get_value "source_password", inner_elt
		        if is_defined(source_password) do
				couchdb = couchdb.source_password(source_password)
			end
		        
		        target_url = :proplists.get_value "target_url", inner_elt
		        couchdb = couchdb.target_url(target_url)
		        target_port = :proplists.get_value "target_port", inner_elt
		        couchdb = couchdb.target_port(target_port)
		        target_dbname = :proplists.get_value "target_dbname", inner_elt
		        couchdb = couchdb.target_dbname(target_dbname)

		        target_username = :proplists.get_value "target_username", inner_elt
		        if is_defined(target_username) do
				couchdb = couchdb.target_username(target_username)
			end
			target_password = :proplists.get_value "target_password", inner_elt
		        if is_defined(target_password) do
				couchdb = couchdb.target_password(target_password)
			end

		        validate(couchdb)
		        couchdbs = [couchdb | couchdbs]
		        {json_elt, couchdbs}
	        end
		{_, couchdbs} = Enum.map_reduce json, couchdbs, f
		IO.puts "couchdbs: #{inspect(couchdbs)}"
		couchdbs

	end

	def validate(couchdb) do
                ensure_defined(couchdb.source_username, "source username")
                ensure_defined(couchdb.target_username, "target username")
                ensure_defined(couchdb.source_password, "source password")
                ensure_defined(couchdb.target_password, "target password")
	end
	
	def is_defined(val) do
		if val == :undefined or val == :null, do: false, else: true
        end

	def ensure_defined(val, description) do
		if is_defined(val) == false, do: raise "Undefined #{description}, must be a string or nil" 
        end


end