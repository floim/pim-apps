###!PIM_APP{
  "name":       "Message History"
, "version":    "0.1.1"
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
    msgBlock = dom.tag('div')
    msgBlock.class "msgBlock"
    msgBlockAvatar = dom.avatar(message.get('authorId'))
    msgBlockAvatar.class "msgBlockAvatar #{msgBlockAvatar.getClass()}"
    msgBlock.append msgBlockAvatar
    msgBlockAuthor = dom.username(message.get('authorId'),'div')
    msgBlockAuthor.class "msgBlockAuthor #{msgBlockAuthor.getClass()}"
    msgBlock.append msgBlockAuthor
    msgBlockMessages = dom.tag('div')
    msgBlockMessages.class "msgBlockMessages"
    if message
      handled = true
      #editId = message.get('editId')
      renderMessage msgBlockMessages, message
    for message in messages
      handled = true
      renderMessage msgBlockMessages, message
    msgBlock.append msgBlockMessages
    dom.append msgBlock
  if !handled
    dom.append(dom.text("Click the date of an edited message to view it's history."))

app.load = ->
  handle = (data={}) ->
    console.log "YAY2! #{data.messageId}"
    app.render {chatId:data.chatId, messageId:data.messageId}
    app.open()
  contentView.on 'click', '.msgContainer', '&.edited .msgDate', handle
  appView.on 'click', '.msgContainer', '&.edited .msgDate', handle
