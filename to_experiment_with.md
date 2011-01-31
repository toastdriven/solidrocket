Things To Experiment With
=========================


General
-------

* Writes should be handled by the main process/thread.
* Use coroutines for all other data (lookups/indexing/etc)?
* Figure out what level of locking is needed.


Deletions
---------

* On delete, insert a special record marking the deletion.
* Start a coroutine to delete the document id out of the lookup tables & the
  index files.


Fast Gets
---------

* Hash key & file offset pairs for fast individual lookups.

  * Use a hash prefix (~6-8 chars?) to segment the keys. This will divide them
    down into lots of little files, which will can be loaded quickly.
  * Maybe JSON? Maybe serialized Lua tables?

* May be worth an LRU cache to keep some frequently accessed lookup tables in
  memory?


Indexing
--------

* Use inverted indexes for indexing some column types (string/numeric).

  * Unique values are their own keys, with a list (table keys ?) of matching
    doc ids as the value.
  * Considering using a similar hash technique, though this may fall down for
    ranges (though this may be inappropriate anyhow).
  * This might cause the need for n-gram-alike lookups (think "startswith" or
    "contains").

* For time-based data, perhaps just store offsets where different times start.

  * Since the data is already in time order, just having an idea of where to
    start/end would make all the difference.

* Consider using bloom filters in addition to narrow things up front faster,
  then further using the index/mapreduce.


Querying
--------

* JQL? JSON as a query langauge
* Keys are the columns
* Values are either exact values or "functions" - think ``contains('dan')``


Clustering
----------

* All requests should hit a ring.
* Appropriate fallbacks to other nodes.
* Maybe a rolling WAL log 

