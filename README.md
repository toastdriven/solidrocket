solidrocket
=========

A schema-less datastore designed to handle heavy writes & fast reads of subsets.

Core Principles:

  * 100% Lua
  * Column-oriented store
  * Consistent writes
  * Able to efficiently handle subsets of the data (think many rows) without
    Map/Reduce
  * Append-only file format
  * Simple backups (tarball the data directory)
  * Simple, tuneable daemon
  * Indexing included
  * Clustering support


HTTP Example
------------

    TBD

Lua Example
-----------

    db = Database('/var/solidrocket/', 'test')
    bucket = Bucket(db, 'users')
    
    bucket.put({
      name='Daniel',
      age=28,
      is_active=true
    })


Running Tests
-------------

``./tests/run_tests.sh``
