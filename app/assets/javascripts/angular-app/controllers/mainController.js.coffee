angular
.module('gradshub-ng.controllers')
.controller('mainController',
  ['$scope', '$rootScope', '$q', 'sessionService', '$state','alertService', '$sce', '$location', 'eventTracker',
   '$anchorScroll', 'stateWrapper', 'modalService', 'navbarService', '$interval', '$timeout',
    ($scope, $rootScope, $q, sessionService, $state, alertService, $sce, $location, eventTracker,
     $anchorScroll, stateWrapper, modalService, navbarService, $interval, $timeout) ->
      callSound = new Audio('/sounds/call_sound.mp3')

      init = ->
        $anchorScroll.yOffset = 0
        $anchorScroll()
        $scope.logged = sessionService.isAuthenticated();
        $scope.profileSpinner = false
        $scope.isOptionsVisible = false
        $scope.navbarService = navbarService #Set navbar service
        # scope methods
        $scope.goToProfile = gotToProfile
        $scope.logout = logout
        $scope.renderHtml = (htmlCode) -> $sce.trustAsHtml(htmlCode)
        $scope.onSearchSubmit = onSearchSubmit
        $scope.clearSearch = clearSearch
        $scope.scrollTo = scrollTo

        $scope.redirectToSettings = () ->
          $state.go 'main.user_settings'

        $scope.showSettingsPopup = ->
          $scope.isOptionsVisible = !$scope.isOptionsVisible

        #Clear navbar options
        $rootScope.$on '$stateChangeStart', () ->
          navbarService.clearOptions()

        initUser()

      logout = ->
        logMeOut = ->
          eventTracker.logOut sessionService.sessionType()
          sessionService.logout()
          $state.go 'main.page', null, {reload: true}
        modalService.confirm("Are you sure you want to leave?").then(logMeOut)

      initUser = ->
        deferrred = $q.defer()
        $scope.profileSpinner = true
        sessionService.requestCurrentUser().then(
          (user) ->
            $state.go 'main.page' if !user?
            $scope.type = sessionService.sessionType().toLowerCase()
            $scope.username = user[$scope.type].name
            $scope.profileSpinner = false
            $scope.isEmployer = $scope.type == 'employer'
            $scope.currentUser = if $scope.isEmployer then user.employer else user.candidate
            deferrred.resolve(user)
        ).catch (error) -> deferrred.reject(error)
        $scope.userPromise = deferrred.promise

      #On search submit redirect to search view. Send keyword parameter.
      onSearchSubmit = ->
        if($scope.searchKeyword)
          $state.go 'main.search', {keyword: $scope.searchKeyword}

      #On mouse down method, clears input when input cross y pressed.
      clearSearch = ($event) ->
        $event.preventDefault(); #Trick to keep input focused.
        $scope.searchKeyword = "" #Clear

      scrollTo = (id)->
        old = $location.hash()
        $location.hash id
        $anchorScroll()
        #reset to old to keep any additional routing logic from kicking in
        $location.hash old
        return

      gotToProfile = ->
        $state.go("main.#{$scope.type}_profile", {uid: 'me'}, { reload: true })

      $rootScope.$on('calling-event', (event, args) ->
        scheduled = $interval( ->
          callSound.play()
        , 2000);
        callSound.play();
        modalService.confirm('You are receving a call! \nWant to chat?', 'Respond', 'Snooze').then( ->
          $interval.cancel(scheduled)
          $timeout( ->
            $state.go('main.communication', {
              receiver: args.event.caller,
              beingCalled: true
            });
          , 100)
        ).catch( ->
          $interval.cancel(scheduled)
        )
      )
        
      init()
  ])