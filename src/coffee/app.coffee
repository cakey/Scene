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
    latlng: [52.234259,0.153287]
    zoom: 15
    name: "Detour"
    description: "Cheeky Gap Year..."
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

displayPoint = (point) ->
    console.log point
    window.map.panTo(new google.maps.LatLng(point.latlng[0], point.latlng[1]))
    window.map.setZoom(point.zoom)

scene = angular.module "scene", []
scene.controller 'FlowCtrl', ['$scope', ($scope) ->
    $scope.selected = -1
    $scope.playing = false
    $scope.story = story

    $scope.playStory = () ->
        if $scope.selected >= story.length-1
            $scope.selected = -1

        $scope.playing = not $scope.playing

        console.log "now playing = " + $scope.playing

        createTimeout = (i) ->
            setTimeout(() ->
                $scope.selected = i
                displayPoint story[i]

                if i >= story.length-1
                    $scope.playing = false

                if $scope.playing
                    $scope.current = createTimeout($scope.selected + 1)

                $scope.$apply()
            , 500)

        if $scope.playing
            $scope.current = createTimeout($scope.selected + 1)
        else
            clearTimeout $scope.current

    $scope.displayPoint = (i) ->
        console.log $scope.selected
        $scope.selected = i
        $scope.playing = false
        clearTimeout $scope.current
        displayPoint story[i]
    ]

scene.filter 'playButtonImage', ->
    (playing) ->
        if playing then "pause" else "play"
 

setMapSize = () ->
    $("#map-canvas").height ($(window).height() + "px")
    width = (($(window).width() - 400) + "px")
    $("#map-canvas").width width
    google.maps.event.trigger(window.map, 'resize')

    $("#info-overlay").css("left", width)

$(window).resize setMapSize


init = () ->
    console.log "init" 
    mapOptions =
        center: new google.maps.LatLng(0.724944,-0.773394),
        zoom: 2

    window.map = new google.maps.Map(document.getElementById("map-canvas"),
            mapOptions)
    setMapSize()
$(init)