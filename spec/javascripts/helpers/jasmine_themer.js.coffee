jQuery ->


  boot = ->
    $('.html-reporter').wrap $('<div></div>').addClass 'container'

  $('body').one('DOMNodeInserted', boot)
  
