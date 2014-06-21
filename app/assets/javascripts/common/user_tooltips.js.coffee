jQuery ->
  show_tooltip = (el, content) ->
    el.popover {
      html: true
      trigger: 'hover'
      content: content
      placement: 'bottom'
    }

  $ 'a.user-tooltip'
    .on 'mouseenter.tooltips',  ->
      $.get "/users/#{$(this).data('id')}/tooltip"
        .done (response) =>
          $ "a.user-tooltip[data-id=#{$(this).data('id')}]"
            .each -> 
              $(@).off 'mouseenter.tooltips'
              show_tooltip $(@), response
          $(@).popover 'show'
          