defmodule Replivisor.Changehandler do
	alias Replivisor.Change, as: Change
	alias Replivisor.Change.ChangeEntry, as: ChangeEntry

	def handle_change(couchdb, change_entry) do
		IO.puts "handle_change called with couchdb: #{inspect(couchdb)} change_entry: #{inspect(change_entry)}"
	end

end