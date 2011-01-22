require("solidrocket/column")


function Bucket(db, name)
  local bucket = {
    db=db,
    name=name,
  }
  
  function bucket:get(id)
    
  end
  
  function bucket:put(data)
    
  end
  
  return bucket
end
