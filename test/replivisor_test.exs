Code.require_file "../test_helper.exs", __FILE__

defmodule ReplivisorTest do
  use ExUnit.Case
  alias Replivisor.Server, as: Server
  alias Replivisor.Config, as: Config
  alias Replivisor.Config.CouchDB, as: CouchDB

  test "experimenting" do
	
	couchdbs = Config.databases
	server_pid = self
	statehash = Replivisor.Couchbeam.monitor_couchdb_list(server_pid, couchdbs)
	IO.puts "statehash: #{inspect(statehash)}"

	assert(true)

  end



end
