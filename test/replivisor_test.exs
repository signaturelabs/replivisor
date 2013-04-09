Code.require_file "../test_helper.exs", __FILE__

defmodule ReplivisorTest do
  use ExUnit.Case
  alias Replivisor.Server, as: Server

  test "experimenting" do
	
	db = Server.init_db
	result = Server.init_track_changes db
	IO.puts "db: #{inspect(db)}" 

	assert(true)

  end
end
