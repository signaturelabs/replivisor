defmodule Replivisor.Changehandler do
	alias Replivisor.Change, as: Change
	alias Replivisor.Change.ChangeEntry, as: ChangeEntry
	alias Replivisor.Couchbeam, as: Couchbeam

	def handle_change(couchdb, change_entry) do
		
		IO.puts "handle_change called with couchdb: #{inspect(couchdb)} change_entry: #{inspect(change_entry)}"
		:timer.sleep(30000)
		IO.puts "wakeup after sleep"
		
		is_present = revision_present_target_db(couchdb, change_entry.deleted, change_entry)
		case is_present do
			true ->
        msg = "Change was detected on target db: #{change_entry.doc_id}@#{change_entry.doc_rev}"
			  log(msg)
			false ->
			  msg = "*** Error, change not detected on target: #{inspect(couchdb)} change_entry: #{inspect(change_entry)}"
			  log(msg)
 			_ ->
			  msg = "*** Error, unexpected result"
			  log(msg)
		end
  end

  def log(msg) do
    msg = "#{msg}\n"
		:file.write_file("output.txt", msg, [:append])
    IO.puts msg                
  end

	def revision_present_target_db(_couchdb, true, _change_entry) do
		# TODO: fix this to handle deleted records
		true
	end
	
	def revision_present_target_db(couchdb, false, change_entry) do
		target_db_rev = latest_rev_target_db(couchdb, change_entry.doc_id)		
		is_target_rev_uptodate(target_db_rev, change_entry.doc_rev)
	end

	def latest_rev_target_db(couchdb, doc_id) do
		{_server, db} = Couchbeam.init_db(couchdb.target_url, 
																			couchdb.target_port, 
																		  couchdb.target_dbname, 
																			couchdb.target_username, 
																		  couchdb.target_password)
		Couchbeam.lookup_revision_from_docid(db, doc_id)
	end

	def is_target_rev_uptodate(nil, _source_rev) do
		false
	end

	def is_target_rev_uptodate(:undefined, _source_rev) do
		false
	end

	def is_target_rev_uptodate(target_rev, source_rev) do
		IO.puts "is_target_rev_uptodate called, target_rev: #{inspect(target_rev)} source_rev: #{inspect(source_rev)}"
		[head|_] = String.split(target_rev, "-") 
		target_rev_number = binary_to_integer(head)
		[head|_] = String.split(source_rev, "-")
		source_rev_number = binary_to_integer(head)
		target_rev_number >= source_rev_number
	end
	

end