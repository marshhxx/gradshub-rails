angular
.module('mepedia.controllers')
.controller('mainController',
  ['$scope', '$rootScope', '$q', 'sessionService', '$state','alertService', '$sce', 'Utils',
    ($scope, $rootScope, $q, sessionService, $state, alertService, $sce, Utils) ->

      init = ->
        $scope.logged = sessionService.isAuthenticated();
        $scope.logout = logout
        $scope.renderHtml = (htmlCode) -> $sce.trustAsHtml(htmlCode)

        initUser()

      logout = ->
        sessionService.logout().then(
          -> $state.go 'home.page', null, {reload: true}
        ).catch(
          (error)-> console.log(error)
        )

      initUser = ->
        deferrred = $q.defer()
        sessionService.requestCurrentUser().then(
          (user) ->
            $state.go 'home.page' if !user?
            type = sessionService.sessionType().toLowerCase()
            $scope.username = user[type].name
            deferrred.resolve(user)
        ).catch (error) -> deferrred.reject(error)
        $scope.userPromise = deferrred.promise

      init()
  ])