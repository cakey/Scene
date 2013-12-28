scene = angular.module "scene", []


StoryProvider = () ->
        {get: (id) ->
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
            return story
        }
scene.service('storyProvider', StoryProvider)



displayPoint = (point) ->
    console.log point
    window.map.panTo(new google.maps.LatLng(point.latlng[0], point.latlng[1]))
    window.map.setZoom(point.zoom)

scene.controller 'FlowCtrl', ['$scope', '$rootScope', 'storyProvider', ($scope, $rootScope, storyProvider) ->
    $scope.selected = -1
    $scope.playing = false
    $scope.story = storyProvider.get(0)

    $scope.playStory = () ->
        if $scope.selected >= $scope.story.length-1
            $scope.selected = -1

        $scope.playing = not $scope.playing

        createTimeout = (i) ->
            setTimeout(() ->
                $scope.selected = i
                displayPoint $scope.story[i]

                if i >= $scope.story.length-1
                    $scope.playing = false

                if $scope.playing
                    $scope.current = createTimeout($scope.selected + 1)

                $scope.$apply()
            , 500)

        if $scope.playing
            clearTimeout $scope.current
            $scope.current = createTimeout($scope.selected + 1)
        else
            clearTimeout $scope.current

    $scope.displayPoint = (i) ->
        if $scope.selected is -1 and i is $scope.story.length -1
            return
        $scope.selected = i
        $scope.playing = false
        clearTimeout $scope.current
        displayPoint $scope.story[i]
    ]

scene.filter 'playButtonImage', ->
    (playing) ->
        if playing then "pause" else "play"
 
scene.directive 'googlemap', ->
    restrict: 'E'
    link: (scope, element, attrs) ->
        setMapSize = ->
            info_overlay_size = 300
            $("#map-canvas").height ($(window).height() + "px")
            width = (($(window).width() - info_overlay_size) + "px")
            $("#map-canvas").width width
            google.maps.event.trigger(window.map, 'resize')
            $("#info-overlay").css("left", width)

        mapOptions =
            center: scope.center
            zoom: scope.zoom

        window.map = new google.maps.Map element[0], mapOptions
        setMapSize()
        $(window).resize setMapSize


scene.controller 'MapCtrl', ['$scope', '$rootScope', ($scope, $rootScope) ->
    $scope.center = new google.maps.LatLng(0.724944,-0.773394)
    $scope.zoom = 2
]
