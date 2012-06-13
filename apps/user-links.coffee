###!PIM_APP
{ "name"    : "User Links"
, "version" : "0.1.0"
, "access"  : ["app","formatter","userCollection"]
}
---
Link to a user's profile in a chat by typing `[user #]` where `#` is their user id, or `@username` where `username` is their username.
###
escapeHTML = formatter.escapeHTML

userLinks = (text, phase, meta) =>
  return formatter.replaceMatches text, /\[user ([0-9]+)\](?!\()/g, (matches) ->
    userId = parseInt matches[1]
    user = userCollection.get(userId)
    if user
      username = user.get('username')
    else
      username = "User #{userId}"
    return formatter.placeholder "<a href='/user/#{userId}' class='username_#{userId}'>#{escapeHTML username}</a>"

atUserLinks = (text, phase, meta) =>
  return formatter.replaceMatches text, /(?:[\s,\.;:]|^)\@([A-Za-z][A-Za-z0-9]{2,19})\b/g, (matches) ->
    username = matches[1]
    users = userCollection.where(username:username)
    if users.length > 0
      userId = users[0].id
      str = formatter.placeholder "<a href='/user/#{userId}' class='username_#{userId}'>@#{escapeHTML username}</a>"
    else
      str = matches[0]
    return str

app.render = ->
  dom.pimFormat "To link to a user's profile just enter `[user #]` where # is the user's ID or username, or do `@username`."

app.load = ->
  formatter.add formatter.PHASE_PLAIN, 80, userLinks
  formatter.add formatter.PHASE_PLAIN, 80, atUserLinks
  return
