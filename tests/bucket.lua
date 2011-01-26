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
      -- Test bucket name checks.
      local b1 = Bucket(db, 'bucket1')
      assert_true(b1:check_bucket_name())
      
      b1.bucket_name = 'test_some-special.chars'
      assert_true(b1:check_bucket_name())
      
      b1.bucket_name = 'test/../some/.../invalid#char$'
      assert_false(b1:check_bucket_name())
    end)
    
    test("generate_id", function()
      local b1 = Bucket(db, 'bucket1')
      local uuid1 = b1:generate_id()
      local uuid2 = b1:generate_id()
      assert_not_equal(uuid1, '')
      assert_not_equal(uuid2, '')
      assert_not_equal(uuid1, uuid2)
    end)
    
    test("get and put", function()
      local b1 = Bucket(db, 'bucket1')
      assert_false(path:exists(path:join({b1:path(), 'username.db'})))
      assert_false(path:exists(path:join({b1:path(), 'age.db'})))
      assert_false(path:exists(path:join({b1:path(), 'is_active.db'})))
      
      local user_id1 = b1:put(nil, {
        username='daniel',
        age=28,
        is_active=true
      })
      
      assert_true(path:exists(path:join({b1:path(), 'username.db'})))
      assert_true(path:exists(path:join({b1:path(), 'age.db'})))
      assert_true(path:exists(path:join({b1:path(), 'is_active.db'})))
      
      -- Test the case where we supply an id.
      local user_id2 = b1:put('joeschmoe', {
        username='joe',
        age=35,
        is_active=false
      })
      
      assert_equal(user_id2, 'joeschmoe')
      
      local user1 = b1:get(user_id1, {'username', 'age', 'is_active'})
      assert_equal(user1['username'], 'daniel')
      assert_equal(user1['age'], 28)
      assert_equal(user1['is_active'], true)
      
      local user2 = b1:get(user_id2, {'username', 'is_active'})
      assert_equal(user2['username'], 'joe')
      assert_equal(user2['age'], nil)
      assert_equal(user2['is_active'], false)
    end)
  end)
end)
