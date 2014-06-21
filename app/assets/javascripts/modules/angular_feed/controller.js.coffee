angular.module 'splity.controllers', []
  .controller 'feedsController', ['$scope', 'Feed', ($scope, Feed) ->
    $scope.feed = Feed.get()
  ]