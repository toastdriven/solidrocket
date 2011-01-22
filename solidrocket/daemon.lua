-- For now, this will just be a test harness.
-- Eventually, this should be the daemon process & accept command line args
-- for configuration like beanstalkd/memcached do.

require("solidrocket/database")
require("solidrocket/bucket")

print("Testing Lua API...")
db = Database('/var/solidrocket/', 'test')
bucket = Bucket(db, 'users')
bucket.put({
  name='Daniel',
  age=28,
  is_active=true,
})
print("Done.")
