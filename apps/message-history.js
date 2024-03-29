// Generated by CoffeeScript 1.3.3
/*!PIM_APP{
  "name":       "Message History"
, "version":    "0.1.1"
, "access":     ["app","chatCollection","contentView","appView"]
}
*/

var renderMessage;

renderMessage = function(root, message) {
  var container, content, date;
  container = dom.tag('div');
  container["class"]("msgContainer");
  date = dom.tag("div");
  date["class"]("msgDate");
  date.append(dom.text(lib.formatDate(message.get('timestamp'))));
  container.append(date);
  content = dom.tag("div");
  content["class"]("msgContent");
  content.pimFormat(message.get('message'));
  container.append(content);
  return root.append(container);
};

app.render = function(args) {
  var chat, handled, message, messages, msgBlock, msgBlockAuthor, msgBlockAvatar, msgBlockMessages, topic, _i, _len;
  dom.q("*").remove();
  chat = chatCollection.get(args != null ? args.chatId : void 0);
  handled = false;
  if (chat != null) {
    topic = chat.get('topic');
    message = chat.messageCollection.get(args != null ? args.messageId : void 0);
    messages = chat.messageCollection.find({
      originalId: args != null ? args.messageId : void 0
    });
    messages.sort(function(a, b) {
      return a.id - b.id;
    });
    msgBlock = dom.tag('div');
    msgBlock["class"]("msgBlock");
    msgBlockAvatar = dom.avatar(message.get('authorId'));
    msgBlockAvatar["class"]("msgBlockAvatar " + (msgBlockAvatar.getClass()));
    msgBlock.append(msgBlockAvatar);
    msgBlockAuthor = dom.username(message.get('authorId'), 'div');
    msgBlockAuthor["class"]("msgBlockAuthor " + (msgBlockAuthor.getClass()));
    msgBlock.append(msgBlockAuthor);
    msgBlockMessages = dom.tag('div');
    msgBlockMessages["class"]("msgBlockMessages");
    if (message) {
      handled = true;
      renderMessage(msgBlockMessages, message);
    }
    for (_i = 0, _len = messages.length; _i < _len; _i++) {
      message = messages[_i];
      handled = true;
      renderMessage(msgBlockMessages, message);
    }
    msgBlock.append(msgBlockMessages);
    dom.append(msgBlock);
  }
  if (!handled) {
    return dom.append(dom.text("Click the date of an edited message to view it's history."));
  }
};

app.load = function() {
  var handle;
  handle = function(data) {
    if (data == null) {
      data = {};
    }
    console.log("YAY2! " + data.messageId);
    app.render({
      chatId: data.chatId,
      messageId: data.messageId
    });
    return app.open();
  };
  contentView.on('click', '.msgContainer', '&.edited .msgDate', handle);
  return appView.on('click', '.msgContainer', '&.edited .msgDate', handle);
};
