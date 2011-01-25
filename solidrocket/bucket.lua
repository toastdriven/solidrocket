require("solidrocket/column")
require("solidrocket/utils/path")


function Bucket(db, bucket_name)
  local bucket = {
    db=db,
    bucket_name=bucket_name,
    _path=Path(),
  }
  
  function bucket:clean_bucket_name()
    -- Slugify the name so as not to allow attacks on files outside the
    -- database root.
    return text.slugify(self.bucket_name)
  end
  
  function bucket:path()
    if not self.bucket_path then
      self.bucket_path = self._path:join({self.db:path(), self:clean_bucket_name()})
    end
    
    return self.bucket_path
  end
  
  function bucket:exists()
    if not self.db:exists() then
      return false
    end
    
    if not self._path:exists(self:path()) then
      return false
    end
    
    if not (self._path:can_read(self:path()) and self._path:can_write(self:path())) then
      return false
    end
    
    return true
  end
  
  function bucket:create()
    return self._path:makedirs(self:path())
  end
  
  function bucket:delete()
    return self._path:rmtree(self:path())
  end
  
  function bucket:get(id)
    
  end
  
  function bucket:put(data)
    
  end
  
  
  -- Final initialization bits.
  if not bucket:exists() == true then
    bucket:create()
  end
  return bucket
end
