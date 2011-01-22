require("luarocks.loader")
require("posix")


function Path(path_separator)
  if path_separator == nil then
    path_separator = '/'
  end
  
  local _path = {
    path_separator=path_separator,
  }
  
  function _path:join(data)
    local path = ''
    
    if #data == 0 then
      return path
    end
    
    -- Pop the first element, so we don't concatenate on an extra separator at
    -- the start.
    path = table.remove(data, 1)
    
    for _, item in ipairs(data) do
      path = path .. self.path_separator .. item
    end
    
    return path
  end
  
  function _path:split(path, sep)
    if not sep then
      sep = self.path_separator
    end
    
    local elements = {}
    local offset = string.find(path, sep)
    
    if not offset then
      table.insert(elements, path)
      return elements
    end
    
    -- Handle leading slash (absolute path).
    if offset == 1 then
      offset = string.find(path, sep, 2)
    end
    
    while offset do
      local bit = string.sub(path, 1, offset - 1)
      table.insert(elements, bit)
      path = string.sub(path, offset + 1)
      offset = string.find(path, sep)
    end
    
    table.insert(elements, path)
    return elements
  end
  
  function _path:dirname(path)
    local bits = self:split(path)
    -- Throw out the last thing on the path.
    table.remove(bits)
    
    -- You're at the top.
    if #bits == 0 then
      if string.find(path, self.path_separator) then
        return self.path_separator
      else
        return ''
      end
    end
    
    return table.concat(bits, self.path_separator)
  end
  
  function _path:basename(path)
    local bits = self:split(path)
    
    if #bits == 0 then
      return ''
    end
    
    return table.remove(bits)
  end
  
  function _path:normpath(path)
    local bits = self:split(path)
    local normed = {}
    local started_at_root = false
    
    if string.sub(path, 1, 1) == self.path_separator then
      started_at_root = true
    end
    
    for i, v in ipairs(bits) do
      if v == '..' then
        -- Can't go higher than the root.
        if #normed > 0 then
          if normed[#normed] == '..' then
            table.insert(normed, v)
          else
            -- Pop off the last thing we pushed in.
            table.remove(normed)
          end
        end
      else
        table.insert(normed, v)
      end
    end
    
    if #normed == 0 then
      return self.path_separator
    end
    
    normed_path = self:join(normed)
    
    if started_at_root then
      if not (string.sub(normed_path, 1, 1) == self.path_separator) then
        normed_path = self.path_separator .. normed_path
      end
    end
    
    return normed_path
  end
  
  function _path:abspath(path)
    return self:normpath(self:join(self.getcwd(), path))
  end
  
  -- Wrap some common posix bits.
  function _path:exists(path)
    return posix.access(path, "f")
  end
  
  function _path:access(path, mode)
    return posix.access(path, mode)
  end
  
  function _path:can_read(path)
    return posix.access(path, "r")
  end
  
  function _path:can_write(path)
    return posix.access(path, "w")
  end
  
  function _path:getcwd()
    return posix.getcwd()
  end
  
  return _path
end
