import dimscord, asyncdispatch, strutils, strformat, options
import tables
import os
import simpleurl

let token = getEnv("BOT_TOKEN")

let discord = newDiscordClient(token)

proc onReady(s: Shard, r: Ready) {.event(discord).} =
  echo "Bot running! Username is " & $r.user

  await s.updateStatus(activity = some ActivityStatus(
    name: "losethegame.com",
    kind: atCustom
  ), status = "idle")

  discard await discord.api.bulkOverwriteApplicationCommands(
    s.user.id,
    @[
      ApplicationCommand(
        name: "shorten",
        description: "Shortens URLS.",
        kind: atSlash,
        options: @[
          ApplicationCommandOption(
            kind: acotStr,
            name: "inputurl",
            description: "The URL you want to shorten.",
            required: some true
          ),
          ApplicationCommandOption(
            kind: acotStr,
            name: "desiredslug",
            description: "What you want to come after the slash.",
            required: some false
          )
        ]
      )
    ]
  )

proc interactionCreate(s: Shard, i: Interaction) {.event(discord).} =
  let data = i.data.get
  var msg = ""
  if data.kind == atSlash:
    case data.name:
      of "shorten":
        let originalURL = data.options["inputurl"].str
        if data.options.hasKey("desiredslug"):
          let desiredSlug = data.options["desiredslug"].str
          let shortenedURL = simpleShorten(originalURL, some desiredSlug)
          msg = &":grin: Your shortened URL is: {shortenedURL}"
        else:
          let shortenedURL = simpleShorten originalURL
          msg = &":grin: Your shortened URL is: {shortenedURL}"
      else:
        msg = ":x: That's not a valid command!"
  
  await discord.api.interactionResponseMessage(i.id, i.token,
    kind = irtChannelMessageWithSource,
    response = InteractionCallbackDataMessage(
      content: msg
    )
  )

waitFor discord.startSession(
  gateway_intents = {giGuildMessages, giGuilds, giGuildMembers, giMessageContent}
)