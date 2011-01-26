require("solidrocket/utils/path")
require("solidrocket/utils/text")


local __author__ = 'Daniel Lindsley'
local __version__ = {0, 0, 1, 'alpha'}


function Database(root_path, database_name)
  local database = {
    root_path=root_path,
    database_name=database_name,
    _path=Path(),
  }
  
  function database:check_database_name()
    return text.check_key(self.database_name)
  end
  
  function database:path()
    if not self:check_database_name() then
      error(string.format("Invalid database name '%q' provided.", self.database_name))
    end
    
    if not self.database_path then
      self.database_path = self._path:join({self.root_path, self.database_name})
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
