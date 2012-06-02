###!PIM_PLUGIN
{ "name"    : "Chat Links"
, "version" : "0.0.4"
, "access"  : ["plugin","formatter","chatCollection"]
}
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

plugin.load = ->
  formatter.add formatter.PHASE_PLAIN, 80, chatLinks
  return

plugin.unload = ->
  formatter.remove formatter.PHASE_PLAIN, 80, chatLinks
  return
