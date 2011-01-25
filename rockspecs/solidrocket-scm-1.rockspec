package = "solidrocket"
version = "scm-1"

source = {}
source.url = "https://github.com/toastdriven/solidrocket/tarball/master"

description = {
   summary = "Solidrocket",
   detailed = "A fun little experimental datastore.",
   homepage = "https://github.com/toastdriven/solidrocket",
   license = "BSD",
   maintainer = "daniel@pragmaticbadger.com",
}

dependencies = {
   "lua >= 5.1",
   "luaposix == 5.1.2",
   "telescope",
}

supported_platforms = {
    "linux",
    "macosx",
}

build = {
    type = "none",
    install = {
        lua = {
            ['solidrocket.bucket'] = 'solidrocket/bucket.lua',
            ['solidrocket.column'] = 'solidrocket/column.lua',
            ['solidrocket.database'] = 'solidrocket/database.lua',
            ['solidrocket.daemon'] = 'solidrocket/daemon.lua',
            ['solidrocket.index'] = 'solidrocket/index.lua',
            ['solidrocket.utils.path'] = 'solidrocket/utils/path.lua',
            ['solidrocket.utils.text'] = 'solidrocket/utils/text.lua',
        }
    }
}