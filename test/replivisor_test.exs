Code.require_file "../test_helper.exs", __FILE__

defmodule ReplivisorTest do
  use ExUnit.Case
  alias Replivisor.Server, as: Server
  alias Replivisor.Config, as: Config
  alias Replivisor.Config.CouchDB, as: CouchDB
  alias Replivisor.Change, as: Change
  alias Replivisor.Change.ChangeEntry, as: ChangeEntry
  alias Replivisor.Couchbeam, as: Couchbeam

  test "experimenting" do
	
	couchdbs = Config.databases
	server_pid = self
	statehash = Couchbeam.monitor_couchdb_list(server_pid, couchdbs)
	IO.puts "statehash: #{inspect(statehash)}"

	couchdb = Enum.at! couchdbs, 0
	{server, db} = Couchbeam.init_db(couchdb.target_url, couchdb.target_port, couchdb.target_dbname)
	rev = Couchbeam.lookup_revision_from_docid(db, "0021C031-AF56-4F22-8357-C7F82ACBC512")
	IO.puts "lookup rev: #{rev}"

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

  test "change handler deleted doc" do
        change_entry = ChangeEntry.new()
        couchdbs = Config.databases
        couchdb = Enum.at! couchdbs, 0
        deleted = true
        result = Replivisor.Changehandler.revision_present_target_db(couchdb, deleted, change_entry)
        assert result == true
  end

  test "change handler target rev up to date" do
  
        target_rev = "3-foo"
        source_rev = "4-foo"
        assert  Replivisor.Changehandler.is_target_rev_uptodate(target_rev, source_rev) == false 
  
        target_rev = "4-foo"
        source_rev = "4-foo"
        assert  Replivisor.Changehandler.is_target_rev_uptodate(target_rev, source_rev) == true

        target_rev = "5-foo"
        source_rev = "4-foo"
        assert  Replivisor.Changehandler.is_target_rev_uptodate(target_rev, source_rev) == true

  end

  test "lookup missing couchdb revision" do
	couchdbs = Config.databases
	couchdb = Enum.at! couchdbs, 0
	{server, db} = Couchbeam.init_db(couchdb.target_url, couchdb.target_port, couchdb.target_dbname)
	rev = Couchbeam.lookup_revision_from_docid(db, "this-id-doesnt-exist")
        assert rev == nil
  end


end
