window.googlePlacesCache = CacheProvider.getCache 'google-places-cache'

return unless params.controller is "activities"

if navigator.geolocation? and window.google?
  navigator.geolocation.getCurrentPosition (position) ->
    coordinates = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    bounds = new google.maps.LatLngBounds coordinates, coordinates
    window.googlePlacesService = new google.maps.places.AutocompleteService null, { bounds: bounds }
    console.log "Location running..."
  , () ->
    console.log arguments

    # CmRTAAAA9pcUXiIPTOa0Y7M7hmkwnSvL-J3sjygOKsQhYYWZ8DvfXj9yQc8Zii8cgST1gO_fH4uLDNZ4qxTXd3LK5R2TkY-GT7L92iQfAedb4Fw4YpohCmDrBx_3iVsEJWWR2OcTEhD4WvgIszyJ4Foc8MM9OOO_GhR5x6d2O58FPjh39gDaKTvCTLUyZA