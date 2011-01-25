require("solidrocket/bucket")
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
  end)
  
  after(function()
    -- Clean up.
    path:rmtree(database_root)
  end)
  
  context("bucket", function()
    test("opening", function()
      -- Make sure the path doesn't exist.
      assert_equal(path:exists(path:join({db:path(), 'bucket1'})), false)

      local b1 = Bucket(db, 'bucket1')
      assert_equal(path:exists(path:join({db:path(), 'bucket1'})), true)

      -- Reopening an existing bucket shouldn't cause an error.
      local b2 = Bucket(db, 'bucket1')
      assert_equal(path:exists(path:join({db:path(), 'bucket1'})), true)

      -- Another bucket alongside shouldn't cause an error.
      assert_equal(path:exists(path:join({db:path(), 'bucket2'})), false)
      
      local b3 = Bucket(db, 'bucket2')
      assert_equal(path:exists(path:join({db:path(), 'bucket2'})), true)
    end)
    
    test("deleting", function()
      -- Test bucket deletion.
      local b3 = Bucket(db, 'bucket2')
      assert_equal(path:exists(path:join({db:path(), 'bucket2'})), true)
      assert_equal(b3:delete(), true)
      assert_equal(path:exists(db:path()), true)
      
      -- Calling delete again shouldn't fail.
      assert_equal(path:exists(path:join({db:path(), 'bucket2'})), false)
      assert_equal(b3:delete(), true)
      assert_equal(path:exists(db:path()), true)
    end)
    
    test("naming", function()
      -- Test bucket name modifications.
      local b4 = Bucket(db, 'bucket1')
      assert_equal(b4:clean_bucket_name(), 'bucket1')
      
      b4.bucket_name = 'test_some-special.chars'
      assert_equal(b4:clean_bucket_name(), 'test_some-special.chars')
      
      b4.bucket_name = 'test/../some/.../invalid#char$'
      assert_equal(b4:clean_bucket_name(), 'test..some...invalidchar')
    end)
  end)
end)
