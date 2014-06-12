class @BaseView

  constructor: () ->

  bindEvents: () ->
    return if !@events? or !@container?
    `
    var that = this, handler;
    for (var eventDescription in that.events) {
      handler = that[that.events[eventDescription]];
      if (typeof handler == 'function') {
        var eventType = eventDescription.split(" ")[0];
        var selector = eventDescription.split(" ")[1];
        (function (h, o, $c, e, s) {
          $(s, $c).bind(e, function () {
            h.apply(o, arguments);
          });
        })(handler, that, that.container, eventType, selector);
      }
    }
    `
    return this



class @BaseCollection

  constructor: (@items) ->

  get: (id) ->
    (item for item in @items when item.id is id)[0]




# Adding a namespacing utility function. Makes sure that the namespace hierarchy exists 
# Usage: namespace("a.b.c.d.e");
# @author: Rohit Garg, ported to coffeescript by Biswarup Chakravarty
# @date: 24 Dec 2013, ported: 11 June 2014

@namespace = (namespace) ->
  object = @
  tokens = namespace.split "."

  until tokens.length is 0
    token = tokens.shift()
    object[token] = {} if not object[token]?
    object = object[token];
  object

@to_params = (o, name) ->
    result = []
    name ?= 'params'
    result.push "#{name}[#{key}]=#{o[key]}" for key, value of o
    return result.join '&'