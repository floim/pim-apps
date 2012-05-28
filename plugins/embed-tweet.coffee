###!PIM_PLUGIN
{
  "name": "Embed Tweet",
  "version": "0.0.6",
  "access": ["formatter","jsonp"],
  "dependencies": [
    "//platform.twitter.com/widgets.js"
  ]
}
###
delay = (ms, cb) -> setTimeout cb, ms

escapeHTML = formatter.escapeHTML

renderTweet = (json) ->
  # TODO: change format to data-datetime = 2012-01-05T19:34:04+00:00
  html =
    """
    <blockquote class="twitter-tweet">
      <p>#{escapeHTML json.text}</p>
      &mdash; #{escapeHTML json.user.name} (@#{escapeHTML json.user.screen_name}) 
      <a href="https://twitter.com/#{escapeHTML json.user.screen_name}/status/#{json.id_str}" data-datetime="#{escapeHTML json.created_at}">#{escapeHTML json.created_at}</a>
    </blockquote>
    """

embedTweet = (text, phase, meta) =>
  regexp = /\[tweet (?:https?:\/\/twitter.com\/[^\/]+\/status\/)?([0-9]+)\](?!\()/g
  while matches = regexp.exec text
    tweetId = matches[1]
    id = (Math.random() * 100000000)
    id = "twitter_oembed_#{id}"
    div = document.createElement 'div'
    div.innerHTML = "Loading"
    url = "https://api.twitter.com/1/statuses/show/#{tweetId}.json?callback=?"
    do (id) ->
      jsonp url, (json) =>
        document.getElementById(id)?.innerHTML = renderTweet json
        twttr?.widgets.load()
        delay 0, ->
          formatter.scrollBottom()
        return
    html = "<div id='#{id}'>Loading tweet #{escapeHTML tweetId}...</div>"
    r = formatter.placeholder html
    text = text.substr(0, matches.index) + r + text.substr(matches.index + matches[0].length)
    regexp.lastIndex = matches.index + r.length
  return text

plugin.load = ->
  formatter.add formatter.PHASE_PLAIN, 80, embedTweet
  return

plugin.unload = ->
  formatter.remove formatter.PHASE_PLAIN, 80, embedTweet
  return
