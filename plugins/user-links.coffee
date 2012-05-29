###!PIM_PLUGIN
{ "name"    : "User Links"
, "version" : "0.0.5"
, "access"  : ["formatter","userCollection"]
}
###
escapeHTML = formatter.escapeHTML

userLinks = (text, phase, meta) =>
  regexp = /\[user ([0-9]+)\](?!\()/g
  while matches = regexp.exec text
    userId = parseInt matches[1]
    user = userCollection.get(userId)
    if user
      username = user.get('username')
    else
      username = "User #{userId}"
    r = formatter.placeholder "<a href='/user/#{userId}' class='username_#{userId}'>#{escapeHTML username}</a>"
    text = text.substr(0, matches.index) + r + text.substr(matches.index + matches[0].length)
    regexp.lastIndex = matches.index + r.length
  return text

atUserLinks = (text, phase, meta) =>
  regexp = /(?:[\s,\.;:]|^)\@([A-Za-z][A-Za-z0-9]{2,19})\b/g
  while matches = regexp.exec text
    username = matches[1]
    users = userCollection.where(username:username)
    if users.length is 0
      continue
    userId = users[0].id
    r = formatter.placeholder "<a href='/user/#{userId}' class='username_#{userId}'>@#{escapeHTML username}</a>"
    text = text.substr(0, matches.index) + r + text.substr(matches.index + matches[0].length)
    regexp.lastIndex = matches.index + r.length
  return text

plugin.load = ->
  formatter.add formatter.PHASE_PLAIN, 80, userLinks
  formatter.add formatter.PHASE_PLAIN, 80, atUserLinks
  return

plugin.unload = ->
  formatter.remove formatter.PHASE_PLAIN, 80, userLinks
  formatter.remove formatter.PHASE_PLAIN, 80, atUserLinks
  return
