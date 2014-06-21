angular.module 'splity.httpService', ['ngResource']
  .factory 'Feed', [
    '$resource', ($resource) ->
      $resource '/api/feed', { }, { }
  ]