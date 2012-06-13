Pim Apps
========

This repository contains simple example apps for [Pim][]. You can write
your own apps and host them anywhere that's publicly accessible over
HTTP - you need not fork this repository unless you want your app
included here. Pim downloads your app and converts it, storing it
locally, so you needn't worry about bandwidth issues.

Overview
--------

Apps are JavaScript files fetched by the Pim server, processed by
[PimScript][], and then made available for all to install and use.

App support is early, so we don't guarantee any level of security at
this point which is why we make apps' source code publicly visible (you
should code with this in mind).

The Pim server uses the information in the app header to pass through
the variables the app has requested access to.

Apps are intended to be able to be loaded and unloaded at will - e.g.
when switching between chats - so most tasks are automatically reversed
when the app unloads. For example if you add a method to the
formatter, when your app is uninstalled that method will be
immediately removed from the formatter without you having to do
anything. All events should be registered in the `app.load` method

App Header
-------------

Apps should start with a header containing a JSON payload followed by a
description. The easiest way to generate this header is to use the [App
Template tool][Pim/developer].

Here's an example:

    ###!PIM_APP{
      "name"    : "Chat Links"
    , "version" : "0.1.1"
    , "access"  : ["app","formatter","chatCollection"]
    }
    -------------
    This app allows you to embed links to other chats in your messages. To
    link to a chat, simply type `[chat #]` where `#` is the id of the chat.
    This will render as the name of the chat as a hyperlink - on clicking
    you will visit that chat.
    ###


#### name
Display name for the app.

#### version
The app's version number, uses [npm's semantic versioning][semver]

#### access
An array of the Pim objects and methods that it needs access to. You
*MUST* include "app" in this list.

Global objects: dom, lib
-----------

PimScript (currently) uses [ADsafe][], so you get access to the
[dom][ADsafe/dom] and lib objects. We've tweaked the dom/bunch objects
so that they contain a `pimFormat` method that clears the current
element and replaces it's content with the results of Pim formatting the
string that is passed through - this is a simple way of rendering rich
text.

Object: app
-----------
The app object represents the app itself. It has two methods
`load` and `render` that should be over-ridden by the app.

`load`: should register all event listeners/callbacks/etc.  
`render`: should populate the app's view with content.

    app.load = function() {
      formatter.add(formatter.PHASE_PLAIN, 80, embedTweet);
    }

    app.render = function(data) {
      dom.pimFormat("To link to a chat, simply type `[chat #]` where `#` is the id of the chat.");
    }

Object: formatter
-----------------

The formatter takes the plain text of messages and converts it into the
HTML that is displayed. The formatter has a number of default actions
and runs in 3 phases: `PHASE_PLAIN`, `PHASE_HTML` and `PHASE_FINAL`.

**You almost certainly want `PHASE_PLAIN`.**

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

`function(text, phase, meta)`

  - text: the current content of the message
  - phase: the phase this method is being called in
  - meta: meta-data about the message being formatted (rarely needed)

Most callbacks run towards the end of `PHASE_PLAIN` and take the form:

    callback = function(text) {
      return formatter.replaceMatches(text, /reg(exp)(here)/gi, function(matches) {
        return formatter.placeholder("Match[1]: " + matches[1]);
      });
    };

Function: jsonp
---------------

`jsonp(key, data, callback)`: fetches JSONP data from the URL specified
by looking up `key` in the `jsonp_urls` hash in the header and inserting
the data specified in `data`, and then calls `callback` with the
results. Have a look at [embed-tweet.js][] (or
[.coffee][embed-tweet.coffee]) for an example.

Object: chatCollection/userCollection
-------------------------------------

These mimic [backbone collections][] containing all the chats/users that
are currently known. These are currently heavily locked down, only
supporting the `.get()` and `.find()` methods. Models contained in
collections support the `.get()` method and an `.id` read-only property.
Chat models also have a `messageCollection` object.

Need more?
==========

Need more access? More documentation? More help? Want to give feedback?
Please get in contact - <apps@p.im> - the app platform is under
constant development so if you can give us a good reason to add
something we probably will.

[semver]: http://npmjs.org/doc/semver.html
[backbone collections]: http://documentcloud.github.com/backbone/#Collection
[Pim]: https://p.im/
[PimScript]: https://github.com/p-im/pim-script
[ADsafe]: http://www.adsafe.org/
[ADsafe/dom]: http://www.adsafe.org/dom.html
[Pim/developer]: https://p.im/developer/
[embed-tweet.js]: https://github.com/p-im/pim-apps/blob/master/apps/embed-tweet.js
[embed-tweet.coffee]: https://github.com/p-im/pim-apps/blob/master/apps/embed-tweet.coffee
