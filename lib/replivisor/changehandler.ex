defmodule Replivisor.Changehandler do
	alias Replivisor.Change, as: Change
	alias Replivisor.Change.ChangeEntry, as: ChangeEntry

	def handle_change(couchdb, change_entry) do
		IO.puts "handle_change called with couchdb: #{inspect(couchdb)} change_entry: #{inspect(change_entry)}"
		:timer.sleep(30000)
		IO.puts "wakeup after sleep"
		
		result = revision_present_target_db(couchdb, change_entry)
		case result do
			:ok ->
			       IO.puts "Change was detected on target db: #{change_entry.doc_id}-#{change_entry.doc_rev}"
			:err ->
			       IO.puts "*** Error, change not detected on target: #{inspect(couchdb)} change_entry: #{inspect(change_entry)}"
 			_ ->
			       IO.puts "*** Error, unexpected result"
		end
        end

	def revision_present_target_db(couchdb, change_entry) do
		:ok
	end

end