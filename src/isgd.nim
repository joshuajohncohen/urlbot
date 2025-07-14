import puppy, uri
import options

converter toOption[T](x: T): Option[T] =
  some(x)

proc isgdShorten*(url: string, shorturl = none(string)): string =
  var endpoint: Uri
  if shorturl.isSome:
    endpoint =
      parseUri("https://is.gd") / "create.php" ?
      {"format": "simple", "url": url, "shorturl": shorturl.get}
  else:
    endpoint =
      parseUri("https://is.gd") / "create.php" ? {"format": "simple", "url": url}

  echo $endpoint

  let resp = get($endpoint)
  if resp.code == 200:
    return resp.body
  else:
    raise CatchableError.newException resp.body

export isgdShorten
