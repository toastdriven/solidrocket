require("solidrocket/utils/path")
require("solidrocket/utils/text")


__author__ = 'Daniel Lindsley'
__version__ = {0, 0, 1, 'alpha'}


function Database(root_path, database_name)
  local database = {
    root_path=root_path,
    database_name=database_name,
    _path=Path(),
  }
  
  function database:clean_database_name()
    -- Slugify the name so as not to allow attacks on files outside the
    -- database root.
    return text.slugify(self.database_name)
  end
  
  function database:path()
    if not self.database_path then
      self.database_path = self._path:join({self.root_path, self:clean_database_name()})
    end
    
    return self.database_path
  end
  
  function database:exists()
    if not self._path:exists(self.root_path) then
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
  
  function database:create()
    return self._path:makedirs(self:path())
  end
  
  function database:delete()
    return self._path:rmtree(self:path())
  end
  
  
  -- Final initialization bits.
  if not database:exists() == true then
    database:create()
  end
  return database
end
