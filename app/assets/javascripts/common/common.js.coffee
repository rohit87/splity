class BaseView

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



class BaseCollection

  constructor: (@items) ->

  get: (id) ->
    (item for item in @items when item.id is id)[0]


# exports
window.BaseCollection = BaseCollection
window.BaseView = BaseView