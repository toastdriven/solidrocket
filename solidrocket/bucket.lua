require("solidrocket/column")
require("solidrocket/utils/path")


function Bucket(db, bucket_name)
  local bucket = {
    db=db,
    bucket_name=bucket_name,
    _path=Path(),
  }
  
  function bucket:check_bucket_name()
    return text.check_key(self.bucket_name)
  end
  
  function bucket:path()
    if not self:check_bucket_name() then
      error(string.format("Invalid bucket name '%q' provided.", self.bucket_name))
    end
    
    if not self.bucket_path then
      self.bucket_path = self._path:join({self.db:path(), self.bucket_name})
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
  
  function bucket:get(id, columns)
    -- For now, you *must* specify a column list.
    -- If desired later, it should be possible to build a file list via glob to
    -- determine all available columns.
    local data = {}
    
    for i,column_name in ipairs(columns) do
      local column = Column(self, column_name)
      data[column_name] = column:get(id)
    end
    
    return data
  end
  
  function bucket:generate_id()
    -- A hook for autogenerating ids.
    -- Default implementation generates a UUID. This kinda sucks but the
    -- alternative (luuid) won't install on OS X for me.
    local uuidgen_file = assert(io.popen('uuidgen', 'r'))
    local uuid = assert(uuidgen_file:read())
    uuidgen_file:close()
    return uuid
  end
  
  function bucket:put(id, data)
    local timestamp = os.time()
    
    if not id then
      id = self:generate_id()
    end
    
    -- TODO: For now, this is sequential. Not sure if parallelizing it makes
    --       sense.
    for k,v in pairs(data) do
      local column = Column(self, k)
      column:write(id, timestamp, v)
    end
    
    return id
  end
  
  
  -- Final initialization bits.
  if not bucket:exists() == true then
    bucket:create()
  end
  return bucket
end
