###!PIM_PLUGIN
{
  "name": "Embed Tweet",
  "version": "0.0.3",
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
      <a href="https://twitter.com/twitter/status/#{json.id_str}" data-datetime="#{escapeHTML json.created_at}">#{escapeHTML json.created_at}</a>
    </blockquote>
    """

embedTweet = (text, phase, meta) =>
  return text.replace /\[tweet (?:https?:\/\/twitter.com\/[^\/]+\/status\/)?([0-9]+)\](?!\()/g, (str) =>
    tweetId = str.match(/^\[tweet (?:https?:\/\/twitter.com\/[^\/]+\/status\/)?([0-9]+)\]$/)[1]
    id = (Math.random() * 100000000)
    id = "twitter_oembed_#{id}"
    div = document.createElement 'div'
    div.innerHTML = "Loading"
    url = "https://twitter.com/statuses/show/#{tweetId}.json?callback=?"
    jsonp url, (json) =>
      document.getElementById(id)?.innerHTML = renderTweet json
      twttr?.widgets.load()
      delay 0, ->
        formatter.scrollBottom()
      return
    html = "<div id='#{id}'>Loading tweet #{escapeHTML tweetId}...</div>"
    return formatter.placeholder html

plugin.load = ->
  formatter.add formatter.PHASE_PLAIN, 80, embedTweet
  return

plugin.unload = ->
  formatter.remove formatter.PHASE_PLAIN, 80, embedTweet
  return
