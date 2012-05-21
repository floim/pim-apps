###!PIM_PLUGIN
{ "name"    : "User Links"
, "version" : "0.0.3"
, "access"  : ["formatter","userCollection"]
}
###
escapeHTML = formatter.escapeHTML

userLinks = (text, phase, meta) =>
  return text.replace /\[user ([0-9]+)\](?!\()/g, (str) =>
    userId = parseInt str.match(/\[user ([0-9]+)\](?!\()/)[1]
    user = userCollection.get(userId)
    if user
      username = user.get('username')
    else
      username = "User #{userId}"
    return formatter.placeholder "<a href='/user/#{userId}' class='username_#{userId}'>#{escapeHTML username}</a>"

atUserLinks = (text, phase, meta) =>
  return text.replace /(?:[\s,\.;:]|^)\@([A-Za-z][A-Za-z0-9]{2,19})\b/g, (str) =>
    username = str.match(/(?:[\s,\.;:]|^)\@([A-Za-z][A-Za-z0-9]{2,19})\b/)[1]
    users = userCollection.where(username:username)
    if users.length is 0
      return str
    userId = users[0].id
    return formatter.placeholder "<a href='/user/#{userId}' class='username_#{userId}'>@#{escapeHTML username}</a>"

plugin.load = ->
  formatter.add formatter.PHASE_PLAIN, 80, userLinks
  formatter.add formatter.PHASE_PLAIN, 80, atUserLinks
  return

plugin.unload = ->
  formatter.remove formatter.PHASE_PLAIN, 80, userLinks
  formatter.remove formatter.PHASE_PLAIN, 80, atUserLinks
  return