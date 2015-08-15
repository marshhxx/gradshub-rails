angular
.module('mepedia.controllers')
.controller('mainController',
  ['$scope', '$rootScope', '$q', 'sessionService', '$state','alertService', '$sce', 'Utils', '$analytics',
    ($scope, $rootScope, $q, sessionService, $state, alertService, $sce, Utils, $analytics) ->

      init = ->
        $scope.logged = sessionService.isAuthenticated();
        $scope.logout = logout
        $scope.renderHtml = (htmlCode) -> $sce.trustAsHtml(htmlCode)

        initUser()
        
      logout = ->
        # Log event in Google Analytics
        $analytics.eventTrack 'Logout', {  category: sessionService.sessionType(), label: 'Save button company logo' }
        
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