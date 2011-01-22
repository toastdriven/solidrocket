require("solidrocket/utils/path")


__author__ = 'Daniel Lindsley'
__version__ = {0, 0, 1, 'alpha'}


function Database(data_path, database_name)
  local database = {
    data_path=data_path,
    database_name=database_name,
  }
  
  function database:exists()
    if not posix.access(self.data_path, "f") then
      return false
    end
    
    if not posix.access(self.data_path, "f") then
      return false
    end
  end
  
  function database:create()
    
  end
  
  function database:delete()
    
  end
  
  if not database:exists() == true then
    database:create()
  end
  return database
end
