Pim Plugins
===========

This repository contains a number of plugin examples for Pim. You can
write your own plugins and host them anywhere that's publicly accessible
over HTTP - you need not fork this repository unless you want your
plugin included here.

Overview
--------

Plugins are JavaScript files fetched by the Pim server, processed, and then made
available for all to use. 

The Pim server uses the information in the plugin header to pass through
the variables the plugin has requested access to. There is currently
nothing to prevent a plugin having full access to the JavaScript
`window` object (this may change in future), so we suggest that you make
the source of your plugins available for inspection by the public. Try
and keep them concise and readable.

Plugins should be able to be loaded and unloaded at will, for example to
enable plugins for only certain chats. As such, plugins should implement
the `load` and `unload` plugin methods (see "Object: plugin").

Plugin Header
-------------

Plugins should start with a header containing a JSON payload describing the plugin, like so:

    /*!PIM_PLUGIN
    { "name"    : "Embed Tweet"
    , "version" : "0.0.3"
    , "access"  : ["formatter","jsonp"]
    }
    */

#### name
Display name for the plugin.

#### version
The plugin's version number, uses [npm's semantic versioning][semver]

#### access
An array of the Pim objects and methods that it needs access to.

Object: plugin
--------------
The plugin object represents the plugin itself. It has two methods
`load` and `unload` that should be over-ridden by the plugin, e.g.

    plugin.load = function() {
      formatter.add(formatter.PHASE_PLAIN, 80, embedTweet);
    }

    plugin.unload = function() {
      formatter.add(formatter.PHASE_PLAIN, 80, embedTweet);
    }

Object: formatter
-----------------

The formatter takes the plain text of messages and converts it into the
HTML that is displayed. The formatter has a number of default actions
and runs in 3 phases: `PHASE_PLAIN`, `PHASE_HTML` and `PHASE_FINAL`.

At the end of `PHASE_PLAIN` the text is converted to HTML by escaping
the HTML entities, and then we enter `PHASE_HTML`.

At the end of `PHASE_HTML` the placeholders (see below) are re-inserted, and then we
enter `PHASE_FINAL`.

### Methods

`formatter.escapeHTML(html)`: returns `html` with its HTML entities
replaced.

`formatter.placeholder(str)`: returns an HTML-safe placeholder string to
be inserted into the message and be replaced with `str` just before
`PHASE_FINAL`. (Use this to prevent further processing e.g. of code
blocks.)

`formatter.scrollBottom()`: if your method loads data asynchronously and
this makes the content reflow, you should call this method to scroll
back to the bottom (if scroll lock is enabled, otherwise
`scrollBottom()` is a no-op).

`formatter.add(phase, priority, callback)`:

  - phase: which phase to run the callback: `formatter.PHASE_PLAIN`, `formatter.PHASE_HTML` or `formatter.PHASE_FINAL`
  - priority: value between 0 (highest, runs first) and 100 (lowest, runs last) - decides when during the phase
    the callback is ran
  - callback: see below

`formatter.remove(phase, priority, callback)`: the opposite of
`formatter.add`

### Callback

`callback(text, phase, meta)`

  - text: the current content of the message
  - phase: the phase this method is being called in
  - meta: meta-data about the message being formatted (rarely needed)

Most callbacks run towards the end of `PHASE_PLAIN` and take the form:

    var callback = function(text, phase, meta) {
      return text.replace(/regexp/g, function(str) {
        return formatter.placeholder("<kbd>HTML content here: " + formatter.escapeHTML(str) + "</kbd>");
      });
    }

Function: jsonp
---------------

`jsonp(url, callback)`: fetches JSONP data from `url` and then calls
`callback` with the results. An example url would be
`https://twitter.com/statuses/show/196948486388858880.json?callback=?` -
note that the second `?` will be replaced automatically.

Object: chatCollection/userCollection
-------------------------------------

These are [backbone collections][] containing all the chats/users that
are currently known.

Need more?
----------

Need more access? More documentation? More help? Want to give feedback? Please get in contact -
<benjie@hasfu.com>

[semver]: http://npmjs.org/doc/semver.html
[backbone collections]: http://documentcloud.github.com/backbone/#Collection
