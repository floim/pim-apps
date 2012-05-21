###!PIM_PLUGIN
{ "name"    : "Chat Links"
, "version" : "0.0.1"
, "access"  : ["formatter","chatCollection"]
}
###
escapeHTML = formatter.escapeHTML

chatLinks = (text, phase, meta) =>
  return text.replace /\[chat ([0-9]+)\](?!\()/g, (str) =>
    chatId = parseInt str.match(/\[chat ([0-9]+)\](?!\()/)[1]
    chat = chatCollection.get(chatId)
    if chat
      chatName = chat.get('topic')
    else
      chatName = "Chat #{chatId}"
    return formatter.placeholder "<a href='/chat/#{chatId}'>#{escapeHTML chatName}</a>"

plugin.load = ->
  formatter.add formatter.PHASE_PLAIN, 80, chatLinks
  return

plugin.unload = ->
  formatter.remove formatter.PHASE_PLAIN, 80, chatLinks
  return
