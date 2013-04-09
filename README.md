# Replivisor - monitor continuous couchdb replications

## What's the problem?

Replivisor grew out of a need to monitor continuous couchdb replications, which can sometimes _silently stop working_.  

In our case, the impetus to build this tool came out of this scenario:

* Continuous push replication from Cloudant -> IrisCouch
* New data was no longer making it to IrisCouch
* In the \_replicator database on Cloudant, the replication state was <code>triggered</code>, so our existing monitoring did not detect the issue.


## How replivisor tries to solve the problem

Replivisor monitors CouchDB replications _from the outside_.  It watches the changes feed of both the source and the target databases, and makes sure that documents are making it to the target within a reasonable amount of time as defined by a threshold.

[Architecture Diagram]

## Replivisor algorithm

* Startup replivisor
* Wait for change on source database
* Spawn a process with that change which monitors target db _changes feed for change with that docid and revision id
* If expected change seen on target db, log it.
* If expected change not seen on target db within timeout, log an error.

## Limitations

* Replivisor is not smart enough to monitor _filtered replications_.

## How to use it

If you point it to one or more _replicator documents, and give it an expected sync time (eg, 30 seconds), it will monitor those replications and log errors if documents are not replicated within the expected time frame.

For example if your _replicator document is:

```
{
   "_id": "master_to_backup",
   "_rev": "5-97bee2b82695e3e4f6462f12c74d5500",
   "source": "http://my_master_couch.io/chessmoves",
   "target": "http://my_backup_couch.io/chessmoves",
   "create_target": false,
   "continuous": true,
   "owner": "admin",
   "_replication_state": "triggered",
   "_replication_state_time": "2013-03-05T03:27:21+00:00",
   "_replication_id": "1fd72378a440d1fc85af89b77cb20f11"
}
```

and you tell Replivisor that the minimum acceptable "out-of-sync" time is 30 seconds, it will monitor the _changes feeds on both source and target, and log errors if any changes on the source db are not propagated to the target within 30 seconds.

## Install replivisor

```
$ git clone github.com/tleyden/replivisor
$ ..
```

## Configure replivisor

Edit the replivisor.yaml file and add entries for each of the replications you want to monitor.  

```
- 
name: backup_chessmoves
url: http://user:pass@my_master_couch.io/_replicator/backup_chessmoves
- 
name: bitcoin_share
url: http://user:pass@my_master_couch.io/_replicator/bitcoin_share
```

## Run replivisor

```
$ ..
```

## Replivisor logs

Replivor writes logs to a file called replivisor.log.  

Example log file

```
Starting replivisor 0.1
Monitoring backup_chessmoves: http://user:pass@my_master_couch.io/_replicator/backup_chessmoves
backup_chessmoves target is in sync with source.  2400 changes analyzed.  latest change seq id: 324234324323
...
backup_chessmoves source seq id: 9879870987
backup_chessmoves source seq id: 9879870987 -> target OK
backup_chessmoves source seq id: 923423421
backup_chessmoves **error, source seq id 923423421 failed to appear on target after 30 seconds.
```

## Setting up alerts

In order to avoid re-inventing the wheel and in the name of keeping things focused and modular, replivisor does not have any built-in functionality for triggering alerts.  All it does is log to a file.

There are a million different ways to setup alerts.  One easy way would be to sign up for your favorite logging-as-a-service such as Loggly or Papertrail, and then send your logs to the service and setup search alerts.  
