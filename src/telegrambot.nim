import telebot, asyncdispatch, logging, options, strutils, os
import simpleurl

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = getEnv("TELEBOT_KEY")

proc updateHandler(bot: TeleBot, update: Update): Future[bool] {.async.} =
  if not update.message.isNil:
    let response = update.message
    if response.text.len > 0:
      let text = response.text
      if text.startsWith("/shorten"):
        let argcount = text.split(' ').len() - 1
        case argcount:
          of 1:
            let inputurl = text.split(' ')[1]
            try:
              let shortenedURL = simpleShorten inputurl
              discard await bot.sendMessage(response.chat.id, "Here is your shortened URL: " & shortenedURL, parseMode = "markdown", disableNotification = true, replyParameters = ReplyParameters(messageId: response.messageId))
            except CatchableError as e:
              discard await bot.sendMessage(response.chat.id, "Error: " & e.msg, parseMode = "markdown", disableNotification = true, replyParameters = ReplyParameters(messageId: response.messageId))
          of 2:
            let inputurl = text.split(' ')[1]
            let slug = text.split(' ')[2]
            try:
              let shortenedURL = simpleShorten(inputurl, some slug)
              discard await bot.sendMessage(response.chat.id, "Here is your shortened URL: " & shortenedURL, parseMode = "markdown", disableNotification = true, replyParameters = ReplyParameters(messageId: response.messageId))
            except CatchableError as e:
              discard await bot.sendMessage(response.chat.id, "Error: " & e.msg, parseMode = "markdown", disableNotification = true, replyParameters = ReplyParameters(messageId: response.messageId))
          else:
            discard await bot.sendMessage(response.chat.id, "Wrong number of arguments", parseMode = "markdown", disableNotification = true, replyParameters = ReplyParameters(messageId: response.messageId))
  return true

proc startCommandHandler(bot: TeleBot, command: Command): Future[bool] {.async.} =
  if not command.message.fromUser.isNil:
    let userName = command.message.fromUser.firstName
    discard await bot.sendMessage(command.message.chat.id, "Hello, " & userName & "! I am urlbot.\\n\\nUse the command /shorten with the URL you want to shorten, plus optionally a custom ending.", parseMode = "markdown", disableNotification = true, replyParameters = ReplyParameters(messageId: command.message.messageId))
  return true

when isMainModule:
  let bot = newTeleBot(API_KEY)

  bot.setLogLevel(levelDebug)

  bot.onUpdate(updateHandler)
  bot.onCommand("help", startCommandHandler)

  echo "Bot started. Polling for updates..."
  bot.poll(timeout = 300)