Code.require_file "../test_helper.exs", __FILE__

defmodule ReplivisorTest do
  use ExUnit.Case
  alias Replivisor.Server, as: Server
  alias Replivisor.Config, as: Config
  alias Replivisor.Config.CouchDB, as: CouchDB

  test "experimenting" do
	
	couchdbs = Config.databases
	Replivisor.Couchbeam.monitor_couchdb_list(self, couchdbs)

	assert(true)

  end



end
