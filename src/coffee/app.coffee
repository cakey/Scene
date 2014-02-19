scene = angular.module "scene", []


StoryProvider = () ->
    get: (id) ->
        story =
            title: "Ben's lifestory..."
            points: [
                latlng: [51.408411,-0.15022]
                zoom: 9
                name: "London"
                description: "Born and raised."
                datetime: "1990-2009"
            ,
                latlng: [52.204,0.118902]
                zoom: 14
                name: "Cambridge"
                description: "The University Years"
                datetime: "2009-2013"
            ,
                latlng: [52.234259,0.153287]
                zoom: 15
                name: "Detour"
                description: "Cheeky Gap Year..."
                datetime: "2012"
            ,
                latlng: [37.735863,-122.414019]
                zoom: 11
                name: "SF"
                description: "Venturing into the wild!"
                datetime: "Sep 2013"
            ,
                latlng: [37.744975,-122.419062]
                zoom: 17
                name: "Bernal Mission"
                description: "I find my home!"
                datetime: "Nov 2013"
            ]
        return story
            
scene.service('storyProvider', StoryProvider)

scene.controller 'FlowCtrl', ['$scope', '$rootScope', 'storyProvider', ($scope, $rootScope, storyProvider) ->
    $scope.selected = -1
    $scope.story = storyProvider.get(0).points
    $scope.title = storyProvider.get(0).title

    displayPoint = (i) ->
        $scope.selected = i
        $rootScope.$emit 'displayPoint', $scope.story[$scope.selected]

    $scope.next = -> displayPoint $scope.selected + 1
    $scope.back = -> displayPoint $scope.selected - 1
    $scope.reset = -> displayPoint 0

    $scope.displayPoint = displayPoint

    ]
 
scene.directive 'googlemap', ['$window', ($window)->
    restrict: 'E'
    link: (scope, element, attrs) ->
        w = angular.element($window)

        makeLatLng = (location) ->
            return new google.maps.LatLng location[0], location[1]

        setMapSize = ->
            info_overlay_size = 300
            element.height w.height()
            element.width w.width()
            google.maps.event.trigger(scope.map, 'resize')

        mapOptions =
            center: makeLatLng scope.center
            zoom: scope.zoom
            disableDefaultUI: true
            zoomControl: false
            panControl: false

        scope.map = new google.maps.Map element[0], mapOptions

        scope.$watch 'center', (latlng) ->
            googleLatLng = makeLatLng latlng
            scope.marker?.setMap null
            scope.marker = new google.maps.Marker(
                position: googleLatLng
                map: scope.map
            )
            scope.map.panTo googleLatLng

        scope.$watch 'zoom', (zoom) ->
            scope.map.setZoom zoom

        setMapSize()
        w.resize setMapSize
]

scene.controller 'MapCtrl', ['$scope', '$rootScope', ($scope, $rootScope) ->
    $scope.center = [0.724944,-0.773394]
    $scope.zoom = 2

    $rootScope.$on 'displayPoint', (event, point) ->
        $scope.center = point.latlng
        $scope.zoom = point.zoom
]
