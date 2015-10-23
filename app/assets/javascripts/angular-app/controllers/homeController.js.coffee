angular.module('gradshub-ng.controllers').controller("HomeController", [
  '$http', '$scope', 'Candidate', 'Employer', '$state', '$anchorScroll', '$location', 'sessionService', '$sce',
  '$stateParams', 'registerService', 'alertService', 'eventTracker', 'navbarService',
  ($http, $scope, Candidate, Employer, $state, $anchorScroll, $location, sessionService, $sce, $stateParams,
   registerService, alertService, eventTracker, navbarService)->
    init = ->
      $scope.renderHtml = (htmlCode) -> $sce.trustAsHtml(htmlCode)
      $scope.isCandidate = () -> $scope.candidate = true
      $scope.isEmployer = () -> $scope.candidate = false
      $scope.carouselInterval = 0 #4000
      $scope.slides = slides

      $scope.type = true
      $scope.showType = ->
        $scope.type = not $scope.type

      $scope.registerUser = registerUser

      navbarService.setOptions($state.current.data.navOptions) # Enable home navigation headers

      $scope.signupLinkedin = () ->
        type = getType()
        IN.User.authorize(->
          sessionService.loginLinkedin(IN.ENV.auth.member_id, IN.ENV.auth.oauth_token, type).then(
            (response) ->
              eventTracker.signUpLinkedIn response.session.type
              $state.go "main.#{response.session.type.toLowerCase()}_profile", {uid: 'me'}, {reload: true}
          ).catch(
            (error) ->
              console.log(error)
          )
        )

    registerUser = (isValid) ->
      userType = ''

      if isValid
        if $scope.candidate
          user = new Candidate()
          userType = 'Candidate'
        else
          user = new Employer()
          userType = 'Employer'
        user.name = $scope.name
        user.lastname = $scope.lastname
        user.email = $scope.email
        user.password = $scope.password
        registerService.register(user).then(
          (payload) ->
            eventTracker.signUp(userType)
            login(registerService.currentUser())
        ).catch(
          (response)->
            $scope.serverErrors = response.data.error
        )
      else
        $scope.submitted = true

    slides = [
      {
        image: "/assets/homepage/home-background.png"
      }
      {
        image: "/assets/homepage/home-background.png"
      }
      {
        image: "/assets/homepage/home-background.png"
      }
    ]

    login = (user) ->
      sessionService.login(user.email, user.password).then(
        (resp) ->
          $state.go "main.signup_#{resp.session.type.toLowerCase()}.personal", null, {reload: true}
      ).catch(
        (errors) ->
          console.log(errors)
      )

    getType = ->
      if $scope.candidate then Candidate.className else Employer.className

    init()
])