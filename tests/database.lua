require("solidrocket/database")
require("solidrocket/utils/path")


function test_database()
  -- Make a test directory we can crap all over in.
  local database_root = '/tmp/solidrockettest'
  local path = Path()
  -- Pre-wipe in case of previous failures.
  path:rmtree(database_root)
  -- Rebuild.
  path:makedirs(database_root)
  
  -- Make sure the path doesn't exist.
  assert(path:exists(path:join({database_root, 'test1'})) == false, "Path to 'test1' exists.")
  
  local db1 = Database(database_root, 'test1')
  assert(path:exists(path:join({database_root, 'test1'})) == true, "Path to 'test1' was not created.")
  
  -- Reopening an existing database shouldn't cause an error.
  local db2 = Database(database_root, 'test1')
  assert(path:exists(path:join({database_root, 'test1'})) == true, "Path to 'test1' can't be loaded.")
  
  -- Another database alongside shouldn't cause an error.
  assert(path:exists(path:join({database_root, 'test2'})) == false, "Path to 'test2' exists.")
  local db3 = Database(database_root, 'test2')
  assert(path:exists(path:join({database_root, 'test2'})) == true, "Path to 'test2' was not created.")
  
  -- Test database deletion.
  local db3 = Database(database_root, 'test2')
  assert(path:exists(path:join({database_root, 'test2'})) == true, "Path to 'test2' does not exist.")
  assert(db3:delete() == true, "Calling delete on database failed.")
  assert(path:exists(path:join({database_root, 'test2'})) == false, "Path to 'test2' was not deleted.")
  assert(db3:delete() == true, "Calling delete on database a second time failed.")
  
  -- Test database name modifications.
  local db4 = Database(database_root, 'test1')
  assert(db4:clean_database_name() == 'test1', "Incorrect cleaning of name 'test1'.")
  db4.database_name = 'test_some-special.chars'
  assert(db4:clean_database_name() == 'test_some-special.chars', "Incorrect cleaning of name 'test_some-special.chars'.")
  db4.database_name = 'test/../some/.../invalid#char$'
  assert(db4:clean_database_name() == 'test..some...invalidchar', "Incorrect cleaning of name 'test/../some/.../invalid#char$'.")
  
  -- Clean up.
  path:rmtree(database_root)
end


test_database()
