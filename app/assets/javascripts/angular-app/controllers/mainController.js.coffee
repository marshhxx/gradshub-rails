angular
.module('mepedia.controllers')
.controller('mainController',
  ['$scope', '$rootScope', '$q', 'sessionService', '$state','alertService', '$sce', '$location', 'eventTracker', '$anchorScroll',
    ($scope, $rootScope, $q, sessionService, $state, alertService, $sce, $location, eventTracker, $anchorScroll) ->

      init = ->
        $scope.logged = sessionService.isAuthenticated();
        $scope.logout = logout
        $scope.renderHtml = (htmlCode) -> $sce.trustAsHtml(htmlCode)
        $scope.profileSpinner = false

        initUser()

      logout = ->
        eventTracker.logOut sessionService.sessionType()
        sessionService.logout().then(
          -> $state.go 'home.page', null, {reload: true}
        ).catch(
          (error)-> console.log(error)
        )

      initUser = ->
        deferrred = $q.defer()
        $scope.profileSpinner = true
        sessionService.requestCurrentUser().then(
          (user) ->
            $state.go 'home.page' if !user?
            type = sessionService.sessionType().toLowerCase()
            $scope.username = user[type].name
            $scope.profileSpinner = false
            deferrred.resolve(user)
        ).catch (error) -> deferrred.reject(error)
        $scope.userPromise = deferrred.promise

      #On search submit redirect to search view. Send keyword parameter.
      $scope.onSearchSubmit = () ->
        if($scope.searchKeyword)
          $state.go 'main.search', {keyword: $scope.searchKeyword}

      #On mouse down method, clears input when input cross y pressed.
      $scope.clearSearch = ($event) ->
        $event.preventDefault(); #Trick to keep input focused.
        $scope.searchKeyword = "" #Clear

      $scope.scrollTo = (id)->
        old = $location.hash()
        $location.hash id
        $anchorScroll()
        #reset to old to keep any additional routing logic from kicking in
        $location.hash old
        return

      $scope.redirectToSettings = () ->
        $state.go 'main.user_settings'


      init()
  ])