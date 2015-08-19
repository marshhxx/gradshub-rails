angular
.module('mepedia.controllers')
.controller('mainController',
  ['$scope', '$rootScope', '$q', 'sessionService', '$state','alertService', '$sce',
    ($scope, $rootScope, $q, sessionService, $state, alertService, $sce) ->

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

      # On search submit redirect to search view. Send keyword parameter. Todo ver como pasar directo la variable
      $scope.onSearchSubmit = () ->
        if($scope.searchKeyword)
          $state.go 'main.search', {keyword: $scope.searchKeyword}

      $scope.clearSearch = () ->
        $scope.searchKeyword = ""
        $scope.clear = true
        $scope.focus = true

      $scope.blur = true
      $scope.focus = false

      $scope.focused = ()->
        console.log("got focus");
        $scope.focus = true
        $scope.blur = false

      $scope.blurred = ()->
        console.log("got blurred");
        if(!$scope.clear)
          $scope.focus = false
          $scope.blur = true
        else
          $scope.focus = true
          $scope.blur = false
          $scope.clear = false


      init()
  ])