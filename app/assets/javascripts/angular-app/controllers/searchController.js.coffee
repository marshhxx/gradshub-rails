angular
.module('mepedia.controllers')
.controller("searchController",
  ['$scope', '$rootScope', '$q', '$http', '$state', 'sessionService', '$stateParams', 'searchService'
    ($scope, $rootScope, $q, $httpProvider, $state, sessionService, $stateParams, searchService)->

      init = ()->
        $scope.keyword = $stateParams.keyword
        # Call search service

      # Display results
      $scope.loadMoreResults = ()->
        searchService.search($scope.keyword).then(
          (response) ->
            $scope.users = response.data.users
        )

      init()
  ])