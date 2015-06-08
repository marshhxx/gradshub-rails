angular
.module('mepedia.controllers')
.controller('mainController',
  ['$scope', '$rootScope', 'sessionService', '$state', 'alertService', '$sce'
    ($scope, $rootScope, sessionService, $state, alertService, $sce) ->
      $scope.logged = sessionService.isAuthenticated();
      $scope.logout = () ->
        sessionService.logout().then(
          -> $state.go 'home.page'
        ).catch(
          (error)-> console.log(error)
        )

      $scope.renderHtml = (htmlCode) -> $sce.trustAsHtml(htmlCode)
  ])