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

* Does not handle auth (still a work in progress)
* Currently ignores deleted documents
* Replivisor is not smart enough to monitor _filtered replications_.

## How to use it

Edit config.ex with the settings of your source and target couch db's

## Install elixir

On OSX:

```
$ brew install elixir
```

See the "elixir-lang website":http://elixir-lang.org/getting_started/1.html for more details.

## Install replivisor

```
$ git clone [replivisor url]
$ mix deps.get
$ mix compile
$ mix test
```

## Run replivisor

Copy the config.json.example to config.json and edit to add the couchdb's you want to monitor.

```
$ iex -S mix
iex> Replivisor.Server.start_link
```

## Replivisor logs

Currently a lot of noise, but anytime you see:

```
*** Error, change not detected on target: […]
```

this means a change was not propagated to the target couchdb within the expected time limit.

## Setting up alerts

In order to avoid re-inventing the wheel and in the name of keeping things focused and modular, replivisor does not have any built-in functionality for triggering alerts.  All it does is log to stdout.

There are a million different ways to setup alerts.  One easy way would be to sign up for your favorite logging-as-a-service such as Loggly or Papertrail, and then send your logs to the service and setup search alerts.  

## Known Issues

- "the dependency does not match the specified version" - fix: update the dependency version in mix.exs to match (root fix still pending)