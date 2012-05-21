/*!PIM_PLUGIN
{
  "name": "Embed Tweet",
  "version": "0.0.3",
  "access": ["formatter","jsonp"],
  "dependencies": [
    "//platform.twitter.com/widgets.js"
  ]
}
*/

var delay, embedTweet, escapeHTML, renderTweet,
  _this = this;

delay = function(ms, cb) {
  return setTimeout(cb, ms);
};

escapeHTML = formatter.escapeHTML;

renderTweet = function(json) {
  var html;
  return html = "<blockquote class=\"twitter-tweet\">\n  <p>" + (escapeHTML(json.text)) + "</p>\n  &mdash; " + (escapeHTML(json.user.name)) + " (@" + (escapeHTML(json.user.screen_name)) + ") \n  <a href=\"https://twitter.com/twitter/status/" + json.id_str + "\" data-datetime=\"" + (escapeHTML(json.created_at)) + "\">" + (escapeHTML(json.created_at)) + "</a>\n</blockquote>";
};

embedTweet = function(text, phase, meta) {
  return text.replace(/\[tweet (?:https?:\/\/twitter.com\/[^\/]+\/status\/)?([0-9]+)\](?!\()/g, function(str) {
    var div, html, id, tweetId, url;
    tweetId = str.match(/^\[tweet (?:https?:\/\/twitter.com\/[^\/]+\/status\/)?([0-9]+)\]$/)[1];
    id = Math.random() * 100000000;
    id = "twitter_oembed_" + id;
    div = document.createElement('div');
    div.innerHTML = "Loading";
    url = "https://twitter.com/statuses/show/" + tweetId + ".json?callback=?";
    jsonp(url, function(json) {
      var _ref;
      if ((_ref = document.getElementById(id)) != null) {
        _ref.innerHTML = renderTweet(json);
      }
      if (typeof twttr !== "undefined" && twttr !== null) {
        twttr.widgets.load();
      }
      delay(0, function() {
        return formatter.scrollBottom();
      });
    });
    html = "<div id='" + id + "'>Loading tweet " + (escapeHTML(tweetId)) + "...</div>";
    return formatter.placeholder(html);
  });
};

plugin.load = function() {
  formatter.add(formatter.PHASE_PLAIN, 80, embedTweet);
};

plugin.unload = function() {
  formatter.remove(formatter.PHASE_PLAIN, 80, embedTweet);
};
