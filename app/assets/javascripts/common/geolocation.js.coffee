window.googlePlacesCache = CacheProvider.getCache 'google-places-cache'

if navigator.geolocation? and window.google?
  navigator.geolocation.getCurrentPosition (position) ->
    coordinates = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    bounds = new google.maps.LatLngBounds coordinates, coordinates
    window.googlePlacesService = new google.maps.places.AutocompleteService null, { bounds: bounds }
    console.log "Location running..."
  , () ->
    console.log arguments