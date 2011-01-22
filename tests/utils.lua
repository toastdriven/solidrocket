require("solidrocket/utils/path")


function test_path()
  local path = Path()
  assert(path.path_separator == '/', "Default path separator is incorrect.")
  assert(path:join({'abc'}) == 'abc', "A single element path is incorrect.")
  assert(path:join({'abc', 'def'}) == 'abc/def', "A two element path is incorrect.")
  assert(path:join({'abc/tmp/foo', 'def'}) == 'abc/tmp/foo/def', "A prebuilt path combined with another element is incorrect.")
  
  local path = Path("\\")
  assert(path.path_separator == "\\", "The overridden path separator is incorrect.")
  assert(path:join({'abc'}) == 'abc', "A single element path with overridden separator is incorrect.")
  assert(path:join({'abc', 'def'}) == 'abc\\def', "A two element path with overridden separator is incorrect.")
  
  local path = Path()
  assert(#path:split('abc') == 1, "Bits of a single element path is incorrect.")
  assert(#path:split('abc/def') == 2, "Bits of a two element path is incorrect.")
  -- for i,v in ipairs(path:bits('/abc/def')) do print(i,v) end
  assert(#path:split('/abc/def') == 2, "Bits of an absolute two element path is incorrect.")
  
  local path = Path()
  assert(path:dirname('/abc/def/ghi') == '/abc/def', "Dirname of three-level path is incorrect.")
  assert(path:dirname('/abc/def') == '/abc', "Dirname of two-level path is incorrect.")
  assert(path:dirname('/abc') == '/', "Dirname of one-level absolute path is incorrect.")
  assert(path:dirname('abc') == '', "Dirname of one-level relative path is incorrect.")
  
  local path = Path()
  assert(path:basename('/abc/def/ghi') == 'ghi', "Basename of three-level path is incorrect.")
  assert(path:basename('/abc/def') == 'def', "Basename of two-level path is incorrect.")
  assert(path:basename('/abc') == '/abc', "Basename of one-level absolute path is incorrect.")
  assert(path:basename('abc') == 'abc', "Basename of one-level relative path is incorrect.")
end


test_path()
