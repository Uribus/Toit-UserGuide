import .secrets    //here we store sensitive data
import telegram show *

import encoding.json
import font show *
//import font-x11-adobe.sans-14-bold
import font-x11-adobe.sans-08-bold
import monitor show Mutex
import net
import http
import certificate-roots

import pixel-display.texture show *
import pixel-display.two-color show *  // Provides WHITE and BLACK.
import pixel-display show *

import ..display_examples.get-display
import ..time.getUpdatedTime

//uselessfacts api params
URL ::= "uselessfacts.jsph.pl"
PATH ::= "/random.json?language=en"
CERTIFICATE ::= certificate-roots.ISRG-ROOT-X1

display-mutex := Mutex
sans ::= Font [
  sans-08-bold.ASCII
]
display ::= get-display

main:
  context := display.context
    --landscape
    --color=BLACK
    --font=sans
  
  //display.filled-rectangle context 00 00 110 35
  screen-context := context.with --alignment=TEXT-TEXTURE-ALIGN-LEFT
  client-texture := display.text screen-context 05 10 "? sent: ?"
  time-texture := display.text screen-context 05 25 "at ??:??"

  //initialize the client with the token given by Telegram, saved in secrets file
  telegramClient := Client --token="$TELEGRAM-TOKEN"
  my-username := telegramClient.get-me.username

  //start listening
  telegramClient.listen: | update/Update? |
    //when a message is received
    if update is UpdateMessage:
      print "Got message: $update"
      message := (update as UpdateMessage).message
      msg-text := message.text
      msg-from := message.from.username
      if message.chat and message.chat.type == Chat.TYPE-PRIVATE:
        //if the message is from the private chat then print it on the device and check for command
        task :: notify-task client-texture time-texture msg-text msg-from
        //if command is fact, retrieve fact from api
        if msg-text == "fact":
          network := net.open
          httpClient := http.Client.tls network
              --root-certificates=[CERTIFICATE]
          request := httpClient.get URL PATH
          decoded := json.decode-stream request.body
          httpClient.close
          network.close
          //and send it to the chat
          task :: sendMsg-task telegramClient message.chat.id message decoded["text"]
        else if msg-text == "today": //if command is today get current date and send it formatted
          time_updt := get-updatedTime.local
          task :: sendMsg-task telegramClient message.chat.id message "Today's date is: $(%04d time_updt.year)-$(%02d time_updt.month)-$(%02d time_updt.day)"
        else if msg-text == "time": //if command is time get current timestamp and send it formatted
          time_updt := get-updatedTime.local
          task :: sendMsg-task telegramClient message.chat.id message "You asked for the time, current time is: $time_updt.h:$(%02d time_updt.m):$(%02d time_updt.s)"
        else: //otherwise answer with Hey!
          task :: sendMsg-task telegramClient message.chat.id message "Hey!"

//task to print on device screen every msg received, with timestamp
notify-task client-texture time-texture message from:
  time_updt := get-updatedTime.local

  display-mutex.do:
    time-texture.text = "at $time_updt.h:$(%02d time_updt.m)"
    client-texture.text = "$from sent: $message"
    display.draw

//task to send message to the chat
sendMsg-task client chatId message msg:
  client.send-message msg
    --chat-id=message.chat.id

