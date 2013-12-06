init = () ->
  console.log "init" 
  mapOptions =
    center: new google.maps.LatLng(-34.397, 150.644),
    zoom: 8

  map = new google.maps.Map(document.getElementById("map-canvas"),
            mapOptions)
google.maps.event.addDomListener(window, 'load', init);