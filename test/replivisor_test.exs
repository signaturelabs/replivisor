Code.require_file "../test_helper.exs", __FILE__

defmodule ReplivisorTest do
  use ExUnit.Case
  alias Replivisor.Server, as: Server
  alias Replivisor.Config, as: Config
  alias Replivisor.Config.CouchDB, as: CouchDB
  alias Replivisor.Change, as: Change
  alias Replivisor.Change.ChangeEntry, as: ChangeEntry

  test "experimenting" do
	
	couchdbs = Config.databases
	server_pid = self
	statehash = Replivisor.Couchbeam.monitor_couchdb_list(server_pid, couchdbs)
	IO.puts "statehash: #{inspect(statehash)}"

	assert(true)

  end

  test "change test" do
	
        id = "00175475-1292-419A-B0C6-B1D457F29528"
        seq = 13182
        rev = "8-2eb257db8a15ada29cfda2eabe3b695d"
	raw_change = {[{"seq",seq},{"id",id},{"changes",[{[{"rev",rev}]}]}]}
        change_item = Change.create_change_entry(raw_change)
        IO.puts "change_item: #{inspect(change_item)}"
	assert(change_item.deleted == false)
	assert(change_item.seq == seq)
	assert(change_item.doc_id == id)
	assert(change_item.doc_rev == rev)

        raw_change = {[{"seq","theseq"},{"id","theid"},{"changes",[{[{"rev","therev"}]}]},{"deleted",true}]}
        change_item = Change.create_change_entry(raw_change)
        assert(change_item.deleted == true)

  end

  test "change handler" do
        change_entry = ChangeEntry.new()
        couchdbs = Config.databases
        couchdb = Enum.at! couchdbs, 0
        Replivisor.Changehandler.handle_change(couchdb, change_entry)
  end


end
