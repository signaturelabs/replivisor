Code.require_file "../test_helper.exs", __FILE__

defmodule ReplivisorTest do

  use ExUnit.Case

  test "the truth" do

    options = []
    server = :couchbeam.server_connection "localhost", 5984, "", options 
    result = :couchbeam.server_info server

    IO.puts "server: #{inspect(server)}"
    IO.puts "result: #{inspect(result)}" 

    assert(true)

  end
end
