angular
.module('gradshub-ng.controllers')
.controller("searchController",
  ['$scope', '$rootScope', '$q', '$http', '$state', 'sessionService', '$stateParams', 'searchService', 'alertService',
    ($scope, $rootScope, $q, $httpProvider, $state, sessionService, $stateParams, searchService, alertService)->
      init = ()->
        $scope.spinnerVisible = false
        $scope.keyword = $stateParams.keyword
        # pagination params
        $scope.totalResults = null
        $scope.currentPage = 1
        $scope.resultsPerPage = 16
        # load initial results
        $scope.loadResults = loadResults
        loadResults($scope.keyword, $scope.currentPage)

      # Display results
      loadResults = (keyword, page) ->
        $scope.spinnerVisible = true
        $scope.users = []
        searchService.search(keyword, page).then(
          (response) ->
            $scope.totalResults = response.headers()['x-total']
            $scope.users = response.data.users
        ).catch(
          (error) -> alertService.defaultErrorCallback(error)
        ).finally(
          -> $scope.spinnerVisible = false
        )

      init()
  ])