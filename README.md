# Replivisor - monitor continuous couchdb replications

## What's the problem?

Replivisor grew out of a need to monitor continuous couchdb replications, which can sometimes _silently stop working_.  

In our case, the impetus to build this tool came out of this scenario:

* Continuous push replication from Cloudant -> IrisCouch
* New data was no longer making it to IrisCouch
* In the \_replicator database on Cloudant, the replication state was <code>triggered</code>, so our existing monitoring did not detect the issue.

## How replivisor attempts to solve the problem

Replivisor monitors CouchDB replications _from the outside_.  It watches the changes feed of both the source and the target databases, and makes sure that documents are making it to the target within a reasonable amount of time as defined by a threshold.

## Replivisor algorithm

* Startup replivisor
* Wait for change on source database
* Spawn a process which waits for 30 seconds, then queries target db to see if that revision (or a later one) is present on target db
* If expected change seen on target db, log it.
* If expected change not seen on target db within timeout, log an error.

## Limitations

* Currently ignores deleted documents
* Replivisor is not smart enough to monitor _filtered replications_.

## Install dependency: erlang + elixir

Replivisor is written in [Elixir](http://elixir-lang.org), and both erlang and elixir will need to be installed.

See the [Elixir Getting Started Guide](http://elixir-lang.org/getting_started/1.html) for more details.

## Install replivisor

```
$ git clone git@github.com:signaturelabs/replivisor.git
$ mix deps.get
$ mix test
```

## Configure replivisor

Copy the config.json.example to config.json and edit to add the couchdb's you want to monitor.

## Run replivisor

```
$ iex -S mix
```

This will start the replivisor application and drop you in an iex shell.  There will be some console output that can be ignored (debug junk).  The meaningful output is in the logs.

## Replivisor logs

Log messages are sent to output.txt in the root of the replivisor directory.

Anytime you see:

```
*** Error, change not detected on target: […]
```

this means a change was not propagated to the target couchdb within the expected time limit.

## Setting up alerts

Replivisor does not have any built-in functionality for sending alerts.  It logs to a file and it is up to you to setup alerts.  

One possible approach is to use [Papertrail](http://papertrailapp.com) and their accompanying [remote-syslog](https://github.com/papertrail/remote_syslog) command line tool.

## Known Issues

- "the dependency does not match the specified version" - fix: update the dependency version in mix.exs to match (root fix still pending)

## TODO

- Needs more reliability measures (currently does not have a supervisor process)

- Use Lager for logging

- Make logging configurable

- Handle deleted documents