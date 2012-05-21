/*!PIM_PLUGIN
{ "name"    : "Chat Links"
, "version" : "0.0.1"
, "access"  : ["formatter","chatCollection"]
}
*/

var chatLinks, escapeHTML,
  _this = this;

escapeHTML = formatter.escapeHTML;

chatLinks = function(text, phase, meta) {
  return text.replace(/\[chat ([0-9]+)\](?!\()/g, function(str) {
    var chat, chatId, chatName;
    chatId = parseInt(str.match(/\[chat ([0-9]+)\](?!\()/)[1]);
    chat = chatCollection.get(chatId);
    if (chat) {
      chatName = chat.get('topic');
    } else {
      chatName = "Chat " + chatId;
    }
    return formatter.placeholder("<a href='/chat/" + chatId + "'>" + (escapeHTML(chatName)) + "</a>");
  });
};

plugin.load = function() {
  formatter.add(formatter.PHASE_PLAIN, 80, chatLinks);
};

plugin.unload = function() {
  formatter.remove(formatter.PHASE_PLAIN, 80, chatLinks);
};
