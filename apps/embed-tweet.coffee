###!PIM_APP
{
  "name": "Embed Tweet",
  "version": "0.1.3",
  "access": ["app","formatter","jsonp","twttr"],
  "jsonp_urls": {
    "status":"https://api.twitter.com/1/statuses/show/{INT:TWEET_ID}.json?callback=?"
  },
  "dependencies": [
    "//platform.twitter.com/widgets.js"
  ]
}
---
This app allows you to embed tweets into chats using twitter's widget API.
To embed a tweet, simply type `[tweet #]` where `#` is the id of the tweet, or the URL to that individual tweet.
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
  return html

fetchTweet = (tweetId, divId, promise) =>
  jsonp "status", {TWEET_ID:tweetId}, (json) =>
    if !json?
      promise.fail "Failed to fetch tweet."
    else
      promise.fulfil renderTweet json
      delay 0, ->
        twttr.loadWidgets()
        delay 0, ->
          formatter.scrollBottom()
    return
  return

embedTweet = (text, phase, meta) =>
  return formatter.replaceMatches text, /\[tweet (?:https?:\/\/twitter.com\/[^\/]+\/status\/)?([0-9]+)\](?!\()/g, (matches) ->
    tweetId = matches[1]
    id = (Math.random() * 100000000)
    id = "twitter_oembed_#{id}"
    {placeholder,promise} = formatter.promise('div',"Loading tweet #{tweetId}...")

    fetchTweet tweetId, id, promise
    return placeholder

app.render = ->
  dom.pimFormat "To embed a tweet, simply type `[tweet #]` where `#` is the id of the tweet, or the URL to that individual tweet."
  return

app.load = ->
  formatter.add formatter.PHASE_PLAIN, 80, embedTweet
  return
