import puppy, uri
import options
import uuids
import json

converter toOption[T](x: T): Option[T] =
  some(x)

proc simpleShorten*(url: string, shorturl = none(string), uuid: string): string =
  let resp = post(
    "https://www.simpleurl.tech/api/anonymous/create-short-url",
    @[("Content-Type", "application/json")],
    $(
      %*{
        "clientId": uuid,
        "domain": "simpleurl.tech",
        "keyword": shorturl,
        "token": "token",
        "url": url,
      }
    ),
  )

  let slug = resp.body.parseJSON["keyword"].getStr()
  let shortenedURL = "https://simpleurl.tech/" & slug

  return shortenedURL

proc simpleShorten*(url: string, shorturl = none(string)): string =
  let uuid = genUUID()

  return simpleShorten(url, shorturl, $uuid)

export simpleShorten
