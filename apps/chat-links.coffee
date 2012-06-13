###!PIM_APP{
  "name"    : "Chat Links"
, "version" : "0.1.1"
, "access"  : ["app","formatter","chatCollection"]
}
-------------
This app allows you to embed links to other chats in your messages. To
link to a chat, simply type `[chat #]` where `#` is the id of the chat.
This will render as the name of the chat as a hyperlink - on clicking
you will visit that chat.
###
escapeHTML = formatter.escapeHTML

chatLinks = (text, phase, meta) =>
  regexp = /\[chat ([0-9]+)\](?!\()/g
  while matches = regexp.exec text
    chatId = parseInt matches[1]
    chat = chatCollection.get(chatId)
    if chat
      chatName = chat.get('topic')
    else
      chatName = "Chat #{chatId}"
    r = formatter.placeholder "<a href='/chat/#{chatId}'>#{escapeHTML chatName}</a>"
    text = text.substr(0, matches.index) + r + text.substr(matches.index+matches[0].length)
    matches.nextIndex = matches.index + r.length
  return text

app.render = ->
  dom.pimFormat "To link to a chat, simply type `[chat #]` where `#` is the id of the chat."

app.load = ->
  formatter.add formatter.PHASE_PLAIN, 80, chatLinks
  return
