jQuery ->

  query_url = (qs) ->
    "/users/#{current_user.id}/activities?#{qs}"

  current_query_and = (object) ->
    q = $.extend {}, params.query, object
    "#{query_url to_params q, 'query'}"

  current_query_but = (key) ->
    q = $.extend {}, params.query
    delete q[key]
    "#{query_url to_params q, 'query'}"

  only = (object) ->
    "#{query_url to_params object, 'query'}"

  # $('.popover-date').each ->
  #   $that = $(@)
  #   $that.popover({
  #     html: true
  #     title: ''
  #     placement: 'bottom'
  #     content: ->
  #       result = $('#tmplActivityDatePopover').html()
  #       $result = $('<div></div>').append($(result))
  #       $link = $result.find('a')
  #       $link.eq(0).attr 'href', only { date: $that.data 'date' }
  #       $link.eq(1).attr 'href', current_query_and { date: $that.data 'date' }
  #       return $result.html()
  #   }).on 'shown.bs.popover', ->
  #     $('body').one 'click', =>
  #       $(@).popover 'hide'

  # $('.popover-location').each ->
  #   $that = $(@)
  #   $that.popover({
  #     html: true
  #     title: ''
  #     placement: 'bottom'
  #     content: ->
  #       result = $('#tmplActivityLocationPopover').html()
  #       $result = $('<div></div>').append($(result))
  #       $link = $result.find('a')
  #       $link.eq(0).attr 'href', only { location: $that.html() }
  #       return $result.html()
  #   }).on 'shown.bs.popover', ->
  #     $('body').one 'click', =>
  #       $(@).popover 'hide'

  $('.popover-date').each ->
    $(@).attr 'href', only { date: $(@).data 'date' }
  $('.popover-location').each ->
    $(@).attr 'href', only { location: $(@).html() }
  $('.popover-person').each ->
    $(@).attr 'href', only { friend: $(@).data('id') }
