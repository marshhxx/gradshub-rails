angular
.module('gradshub-ng.controllers')
.controller("searchController",
  ['$scope', '$rootScope', '$q', '$http', '$state', 'sessionService', '$stateParams', 'searchService', 'alertService',
    ($scope, $rootScope, $q, $httpProvider, $state, sessionService, $stateParams, searchService, alertService)->

      init = ()->
        $scope.spinnerVisible = false
        $scope.keyword = $stateParams.keyword
        loadResults($scope.keyword)

      # Display results
      loadResults = (keyword)->
        $scope.spinnerVisible = true
        searchService.search(keyword).then(
          (response) ->
            $scope.users = response.data.users
        ).catch(
          (error) -> alertService.defaultErrorCallback(error)
        ).finally(
          -> $scope.spinnerVisible = false
        )

      init()
  ])