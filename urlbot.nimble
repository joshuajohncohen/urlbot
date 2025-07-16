# Package

version       = "0.1.0"
author        = "Joshua Cohen"
description   = "A bot for URL shortening on platforms like Discord"
license       = "MIT"
srcDir        = "src"
bin           = @["urlbot"]


# Dependencies

requires "nim >= 2.0.0"

requires "puppy >= 2.1.2"
requires "uuids >= 0.1.12"
requires "dimscord >= 1.6.0"
