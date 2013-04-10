defmodule Replivisor.Change do

	defrecord ChangeEntry, seq: nil, 
		               doc_id: nil, 
		               deleted: nil,
		               doc_rev: nil

        def create_change_entry(raw_change) do
		# example raw_change: 
		# 
		# {[{"seq",13184},{"id","00175475-1292-419A-B0C6-B1D457F29528"},
		# {"changes",[{[{"rev","10-c1969bcb3b1673e4299226bcdb214f05"}]}]},{"deleted",true}]}

		{change_attributes} = raw_change
		
		change_entry = ChangeEntry.new(deleted: false)
		f = fn change_attribute, change_entry ->
		        {key, val} = change_attribute
		        case key do
				"seq" ->
				        change_entry = change_entry.seq(val)
				"id" ->
				        change_entry = change_entry.doc_id(val)
				"changes" ->
				        [{[{"rev",rev}]}] = val  
				        change_entry = change_entry.doc_rev(rev)
				"deleted" ->
				        change_entry = change_entry.deleted(val)
				_ ->
				        IO.puts "Unknown key: #{key}"
			end
		        {change_attribute, change_entry}
	        end
		{_, change_entry} = Enum.map_reduce change_attributes, change_entry, f
		change_entry

	end


end