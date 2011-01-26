require("solidrocket/bucket")
require("solidrocket/column")
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
    db = Database(database_root, 'test1')
    b1 = Bucket(db, 'bucket1')
  end)
  
  after(function()
    -- Clean up.
    path:rmtree(database_root)
  end)
  
  context("column", function()
    test("filenaming", function()
      local c1 = Column(b1, 'username')
      assert_equal(c1:column_filename(), 'username.db')
    end)
    
    test("pathing", function()
      local c1 = Column(b1, 'username')
      assert_equal(c1:path(), path:join({b1:path(), 'username.db'}))
    end)
    
    test("get", function()
      -- Stub some files.
      local usernames_file = io.open(path:join({b1:path(), 'username.db'}), 'w')
      usernames_file:write('DB3708F0-B76D-49DF-84F2-921B058552F4|1296028339|daniel\n')
      usernames_file:write('DB3708F1-B76D-49DF-84F2-921B058552F4|1296028350|joe\n')
      usernames_file:write('DB3708F2-B76D-49DF-84F2-921B058552F4|1296028421|mary\n')
      usernames_file:close()
      
      local c1 = Column(b1, 'username')
      local value1 = c1:get('DB3708F0-B76D-49DF-84F2-921B058552F4')
      assert_equal(value1, 'daniel')
      
      local value2 = c1:get('DB3708F2-B76D-49DF-84F2-921B058552F4')
      assert_equal(value2, 'mary')
    end)
    
    test("put", function()
      local c1 = Column(b1, 'username')
      assert_false(path:exists(path:join({b1:path(), 'username.db'})))
      
      c1:write('daniellindsley', 1296028339, 'daniel')
      c1:write('joeschmoe', 1296028350, 'joe')
      
      assert_true(path:exists(path:join({b1:path(), 'username.db'})))
      local usernames_file = io.open(path:join({b1:path(), 'username.db'}), 'r')
      local username1 = usernames_file:read()
      assert_equal(username1, 'daniellindsley|1296028339|daniel')
      local username2 = usernames_file:read()
      assert_equal(username2, 'joeschmoe|1296028350|joe')
      usernames_file:close()
    end)
  end)
end)
