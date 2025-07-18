import nimpy, simpleurl, options

proc simpleShort(url: string): string {.exportpy.} =
  return simpleShorten url

proc simpleShortC(url, shorturl: string): string {.exportpy.} =
  return simpleShorten(url, some shorturl)