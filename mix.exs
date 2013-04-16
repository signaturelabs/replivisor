defmodule Replivisor.Mixfile do
  use Mix.Project

  def project do
    [ app: :replivisor,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:couchbeam],
     registered: [:replivisor],
     mod: {Replivisor, []}
    ]
  end

  # Returns the list of dependencies in the format:
  defp deps do
    [{:mochiweb, "2.5.0", git: "http://github.com/mochi/mochiweb.git"},
     {:jiffy, "0.3.0-37-g138bc88", git: "http://github.com/refuge/jiffy.git"},
     {:oauth, "1.2.2", git: "http://github.com/refuge/erlang-oauth.git"},
     {:ibrowse, "4.0.1", git: "http://github.com/cmullaparthi/ibrowse.git"},
     {:couchbeam, "0.8.1", git: "https://github.com/benoitc/couchbeam.git"}]
  end
end
