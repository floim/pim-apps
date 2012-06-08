###!PIM_APP{
  "name":       "Message History"
, "version":    "0.1.0"
, "access":     ["app","chatCollection","contentView","appView"]
}###

renderMessage = (root, message) ->
  container = dom.tag('div')
  container.class "msgContainer"
  date = dom.tag "div"
  date.class "msgDate"
  date.append dom.text lib.formatDate(message.get('timestamp'))
  container.append date
  content = dom.tag "div"
  content.class "msgContent"
  content.pimFormat message.get('message')
  container.append content
  root.append container

app.render = (args) ->
  dom.q("*").remove()
  chat = chatCollection.get args?.chatId
  handled = false
  if chat?
    topic = chat.get('topic')
    message = chat.messageCollection.get args?.messageId
    messages = chat.messageCollection.find {originalId:args?.messageId}
    messages.sort (a,b) -> a.id - b.id
    if message
      handled = true
      #editId = message.get('editId')
      renderMessage dom, message
    for message in messages
      handled = true
      renderMessage dom, message
  if !handled
    dom.append(dom.text("Benjie woz 'ere (#{topic})"))

app.load = ->
  console.log "HELLO!"
  contentView.on 'click', '.msgContainer', '&.edited .msgDate', (data={}) ->
    console.log "YAY2! #{data.messageId}"
    app.render {chatId:data.chatId, messageId:data.messageId}
    app.open()
  appView.delegate 'click .message .edited .msgDate', ->
    console.log "YAY!"

app.unload = ->
  console.log "GOODBYE!"
