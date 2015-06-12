angular
.module('mepedia.controllers')
.controller('mainController',
  ['$scope', '$rootScope', 'sessionService', '$state', 'alertService', '$sce', 'Utils',
    ($scope, $rootScope, sessionService, $state, alertService, $sce, Utils) ->

      init = ->
        $scope.logged = sessionService.isAuthenticated();
        $scope.logout = logout
        $scope.renderHtml = (htmlCode) -> $sce.trustAsHtml(htmlCode)

        initUser()

      logout = ->
        sessionService.logout().then(
          -> $state.go 'main.page'
        ).catch(
          (error)-> console.log(error)
        )

      initUser = ->
        $scope.userPromise = sessionService.requestCurrentUser().then(
          (user) ->
            $state.go 'main.page' if !user?
            type = sessionService.sessionType().toLowerCase()
            $scope.username = user[type].name
            return user
        ).catch(
          (error) ->
            console.log error
            $state.go 'main.page'
        )

      init()
  ])