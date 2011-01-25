require("luarocks.loader")
require("posix")
require("solidrocket/utils/path")
require("solidrocket/utils/text")


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
  
  local path = Path()
  assert(path:normpath('/abc') == '/abc', "Normalization of one-level path is incorrect.")
  assert(path:normpath('/abc/def') == '/abc/def', "Normalization of two-level path is incorrect.")
  assert(path:normpath('/abc/def/ghi') == '/abc/def/ghi', "Normalization of three-level path is incorrect.")
  assert(path:normpath('/') == '/', "Normalization of root path is incorrect.")
  assert(path:normpath('/abc/def/..') == '/abc', "Normalization of trailing '..' path is incorrect.")
  assert(path:normpath('/abc/def/../ghi') == '/abc/ghi', "Normalization of middle '..' path is incorrect.")
  assert(path:normpath('/abc/../def/../ghi') == '/ghi', "Normalization of multiple '..' path is incorrect.")
  assert(path:normpath('/abc/../../../def/../ghi') == '/ghi', "Normalization of too many '..' path is incorrect.")
  assert(path:normpath('abc/../def/../ghi') == 'ghi', "Normalization of simple relative '..' path is incorrect.")
  assert(path:normpath('abc/../../../def/../ghi') == '../../ghi', "Normalization of complex relative '..' path is incorrect.")
  
  local path = Path()
  local current_cwd = posix.getcwd()
  local abs_path = string.format('%s/abc/def', current_cwd)
  assert(path:abspath('abc/def') == abs_path, "Building absolute path is incorrect.")
end


function test_text()
  assert(text.split('abc')[1] == 'abc', "Single word text split is incorrect.")
  assert(text.split('abc def')[1] == 'abc', "First word of a two-word text split is incorrect.")
  assert(text.split('abc def')[2] == 'def', "Second word of a two-word text split is incorrect.")
  assert(text.split('abc def ghi')[1] == 'abc', "First word of a three-word text split is incorrect.")
  assert(text.split('abc def ghi')[2] == 'def', "Second word of a three-word text split is incorrect.")
  assert(text.split('abc def ghi')[3] == 'ghi', "Third word of a three-word text split is incorrect.")
  assert(text.split('abc def/ghi')[1] == 'abc', "First word of a two-word-special-character text split is incorrect.")
  assert(text.split('abc def/ghi')[2] == 'def/ghi', "Second word of a two-word-special-character text split is incorrect.")
  assert(text.split('abc def/ghi', '/')[1] == 'abc def', "First word of an overridden two-word-special-character text split is incorrect.")
  assert(text.split('abc def/ghi', '/')[2] == 'ghi', "Second word of an overridden two-word-special-character text split is incorrect.")
  
  assert(text.slugify('abc') == 'abc', "Single word slugify is incorrect.")
  assert(text.slugify('abc def') == 'abc-def', "Space-handling slugify is incorrect.")
  assert(text.slugify('abc_def') == 'abc_def', "Underscore-handling slugify is incorrect.")
  assert(text.slugify('abc.def') == 'abc.def', "Period-handling slugify is incorrect.")
  assert(text.slugify('AaBbCc_DdEeFf') == 'aabbcc_ddeeff', "Mixed-case-handling slugify is incorrect.")
  assert(text.slugify('a#$%b_-c(*$).\\d{e>f') == 'ab_-c.def', "Multi-character-handling slugify is incorrect.")
  assert(text.slugify('abc/../../../etc/passwd') == 'abc......etcpasswd', "Attempted path-manipulation of slugify is incorrect.")
end


test_path()
test_text()
