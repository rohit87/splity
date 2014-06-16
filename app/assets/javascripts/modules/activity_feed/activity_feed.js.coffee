class @ActivityFeed
  

class @ActivityFeedView
  constructor: (@container, @options) ->
    @activities = []
    @createActivityViews()

  createActivityViews: ->
    @activities.push(new ActivityView $(activity), {}, @) for activity in @container.find ".activity"


class @Activity



class @ActivityView
  constructor: (@container, @options, @feed) ->
    @initializeUI()
    @bindEvents()

  initializeUI: ->
    @expandedContent = @container.find('.expanded-content')
    @contractedContent = @container.find('.contracted-content')
    @expanded = false

  expand: ->
    @container.addClass('activity-expanded').removeClass('activity-collapsed')
    @expanded = true
    $('<div class=activity-separator></div>').insertBefore(@container)
    $('<div class=activity-separator></div>').insertAfter(@container)

  collapse: ->
    @container.removeClass('activity-expanded').addClass('activity-collapsed')
    @expanded = false
    @container.prev('.activity-separator').remove()
    @container.next('.activity-separator').remove()

  toggle: ->
    if @expanded then @collapse() else @expand()

  bindEvents: ->
    @container.on 'click', =>
      activity.collapse() for activity in @feed.activities when activity isnt @
      @toggle()



jQuery ->
  window.activityFeed = new ActivityFeedView $('#divActivityFeed'), {}