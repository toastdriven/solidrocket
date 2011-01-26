require("solidrocket/utils/path")
require("solidrocket/utils/text")


function Column(bucket, column_name)
  local column = {
    bucket=bucket,
    column_name=column_name,
    _path=Path()
  }
  
  function column:column_filename()
    if not text.check_key(self.column_name) then
      error(string.format("Invalid column name '%q' provided.", self.column_name))
    end
    
    return string.format("%s.db", self.column_name)
  end
  
  function column:path()
    if not self.column_path then
      self.column_path = self._path:join({self.bucket:path(), self:column_filename()})
    end
    
    return self.column_path
  end
  
  function column:get(original_id)
    -- FIXME: Inefficient, but for now we'll iterate over everything until
    --        we find the key. MapReduce FTL.
    local final_value = nil
    local id = nil
    local timestamp = nil
    local value = nil
    
    for line in io.lines(self:path()) do
      id, timestamp, value = string.match(line, "^([%w_.-]+)|(%d+)|(.*)$")
      
      if id then
        if original_id == id then
          final_value = value
        end
      end
    end
    
    return final_value
  end
  
  function column:write(id, timestamp, value)
    -- FIXME: May need some locking here.
    local column_filename = self:path()
    local column_file = io.open(column_filename, 'a+')
    column_file:write(string.format("%s|%s|%s\n", id, timestamp, tostring(value)))
    column_file:close()
  end
  
  
  return column
end
