text = {}

function text.split(original, sep)
  if not sep then
    sep = ' '
  end
  
  local elements = {}
  local altered = original
  local offset = string.find(altered, sep)
  
  if not offset then
    table.insert(elements, altered)
    return elements
  end
  
  while offset do
    local bit = string.sub(altered, 1, offset - 1)
    table.insert(elements, bit)
    altered = string.sub(altered, offset + 1)
    offset = string.find(altered, sep)
  end
  
  table.insert(elements, altered)
  return elements
end

function text.slugify(original)
  -- Only allow [A-Za-z0-9_.-] characters.
  local altered = string.lower(original)
  -- Convert spaces to dashes first.
  altered, count = string.gsub(altered, '%s+', '-')
  -- Nuke any remaining disallowed characters.
  new_string, count = string.gsub(altered, '[^a-z0-9_.-]', '')
  return new_string
end
