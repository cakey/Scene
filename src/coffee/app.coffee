story = [
    latlng: [51.408411,-0.15022]
    zoom: 9
    name: "London"
    description: "Born and raised."
,
    latlng: [52.204,0.118902]
    zoom: 14
    name: "Cambridge"
    description: "The University Years"
,
    latlng: [37.735863,-122.414019]
    zoom: 11
    name: "SF"
    description: "Venturing into the wild!"
,
    latlng: [37.744975,-122.419062]
    zoom: 17
    name: "Bernal Mission"
    description: "I find my home!"
]

scene = angular.module "scene", []
scene.controller 'FlowCtrl', ['$scope', ($scope) ->
    $scope.state = "pause"
    $scope.story = story
    ]

setMapSize = () ->
    $("#map-canvas").height ($(window).height() + "px")
    width = (($(window).width() - 400) + "px")
    $("#map-canvas").width width
    google.maps.event.trigger(window.map, 'resize')

    $("#info-overlay").css("left", width)

$(window).resize setMapSize

displayPoint = (point) ->
    console.log point
    window.map.panTo(new google.maps.LatLng(point.latlng[0], point.latlng[1]))
    window.map.setZoom(point.zoom)
    $("#desc").text(point.name + " : " + point.description)

playStory = () ->
    console.log "playing story"
    createTimeout = (point, i) ->
        setTimeout(() ->
            displayPoint(point)
        , (i+1)*1500) 
    for point, i in story
        createTimeout(point, i)
   
$("#play").click playStory

init = () ->
    console.log "init" 
    mapOptions =
        center: new google.maps.LatLng(0.724944,-0.773394),
        zoom: 2

    window.map = new google.maps.Map(document.getElementById("map-canvas"),
            mapOptions)
    setMapSize()
$(init)