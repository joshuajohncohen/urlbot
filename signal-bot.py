import os
from signalbot import SignalBot, Command, Context
from simplepy import *


class ShortenURL(Command):
    async def handle(self, c: Context):
        if c.message.text.startswith("!shorten"):
            argcount = len(c.message.test.split(" ")) - 1
            if argcount == 0:
                await c.send("You have to provide arguments!")
            elif argcount == 1:
                inputurl = c.message.test.split(" ")[1]
                try:
                    outputurl = simpleShort(inputurl)
                    await c.send("The shortened URL is: " + outputurl)
                except Exception as e:
                    await c.send(str(e))
            elif argcount == 2:
                inputurl = c.message.test.split(" ")[1]
                slug = c.message.test.split(" ")[2]
                try:
                    outputurl = simpleShortC(inputurl, slug)
                    await c.send("The shortened URL is: " + outputurl)
                except Exception as e:
                    await c.send(str(e))
            await c.send("You did something wrong")


if __name__ == "__main__":
    bot = SignalBot({
        "signal_service": os.environ["SIGNAL_SERVICE"],
        "phone_number": os.environ["PHONE_NUMBER"]
    })
    bot.register(ShortenURL()) # all contacts and groups
    bot.start()