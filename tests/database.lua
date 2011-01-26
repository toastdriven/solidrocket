require("solidrocket/database")
require("solidrocket/utils/path")


context("solidrocket", function()
  before(function()
    -- Make a test directory we can crap all over in.
    database_root = '/tmp/solidrockettest'
    path = Path()
    -- Pre-wipe in case of previous failures.
    path:rmtree(database_root)
    -- Rebuild.
    path:makedirs(database_root)
  end)
  
  after(function()
    -- Clean up.
    path:rmtree(database_root)
  end)
  
  context("database", function()
    test("opening", function()
      -- Make sure the path doesn't exist.
      assert_equal(path:exists(path:join({database_root, 'test1'})), false)

      local db1 = Database(database_root, 'test1')
      assert_equal(path:exists(path:join({database_root, 'test1'})), true)

      -- Reopening an existing database shouldn't cause an error.
      local db2 = Database(database_root, 'test1')
      assert_equal(path:exists(path:join({database_root, 'test1'})), true)

      -- Another database alongside shouldn't cause an error.
      assert_equal(path:exists(path:join({database_root, 'test2'})), false)
      
      local db3 = Database(database_root, 'test2')
      assert_equal(path:exists(path:join({database_root, 'test2'})), true)
    end)
    
    test("deleting", function()
      -- Test database deletion.
      local db3 = Database(database_root, 'test2')
      assert_equal(path:exists(path:join({database_root, 'test2'})), true)
      assert_equal(db3:delete(), true)
      
      -- Calling delete again shouldn't fail.
      assert_equal(path:exists(path:join({database_root, 'test2'})), false)
      assert_equal(db3:delete(), true)
    end)
    
    test("naming", function()
      -- Test database name checks.
      local db4 = Database(database_root, 'test1')
      assert_true(db4:check_database_name())
      
      db4.database_name = 'test_some-special.chars'
      assert_true(db4:check_database_name())
      
      db4.database_name = 'test/../some/.../invalid#char$'
      assert_false(db4:check_database_name())
    end)
  end)
end)
