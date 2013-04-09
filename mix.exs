defmodule Replivisor.Mixfile do
  use Mix.Project

  def project do
    [ app: :replivisor,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  defp deps do
    [{:mochiweb, ".*", git: "http://github.com/mochi/mochiweb.git"},
     {:jiffy, ".*", git: "http://github.com/refuge/jiffy.git"},
     {:oauth, ".*", git: "http://github.com/refuge/erlang-oauth.git"},
     {:ibrowse, ".*", git: "http://github.com/cmullaparthi/ibrowse.git"},
     {:couchbeam, ".*", git: "https://github.com/benoitc/couchbeam.git"}]
  end
end
