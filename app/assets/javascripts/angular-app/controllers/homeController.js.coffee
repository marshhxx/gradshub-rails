angular.module('mepedia.controllers').controller("HomeController", [
  '$http', '$scope', 'Candidate', 'Employer', '$state', '$anchorScroll', '$location', 'sessionService', '$sce',
  '$stateParams', 'registerService', 'alertService', '$window', 'eventTracker',
  ($http, $scope, Candidate, Employer, $state, $anchorScroll, $location, sessionService, $sce, $stateParams,
   registerService, alertService, $window, eventTracker)->

    if sessionService.isAuthenticated()
      if sessionService.sessionType() == "Candidate"
        $state.go 'main.candidate_profile', {uid: 'me'}
      else
        $state.go 'main.employer_profile', {uid: 'me'}

    init = ->
      $scope.renderHtml = (htmlCode) -> $sce.trustAsHtml(htmlCode)
      $scope.isCandidate = () -> $scope.candidate = true
      $scope.isEmployer = () -> $scope.candidate = false
      $scope.carouselInterval = 0 #4000
      $scope.slides = slides
      $scope.rlslides = rlslides
      $scope.type = true
      $scope.showType = ->
        $scope.type = not $scope.type

      $scope.registerUser = registerUser

      $scope.signupLinkedin = () ->
        type = getType()
        IN.User.authorize( ->
          sessionService.loginLinkedin(IN.ENV.auth.member_id, IN.ENV.auth.oauth_token, type).then(
            (response) ->
              eventTracker.signUpLinkedIn response.type
              $state.go "main.#{response.type.toLowerCase()}_profile", {uid: 'me'}, {reload: true}
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
        image: "/assets/homepage/home-background.jpeg"
      }
      {
        image: "/assets/homepage/home-background.jpeg"
      }
      {
        image: "/assets/homepage/home-background.png"
      }
    ]

    rlslides = [
      {
        image: "/assets/home-real-lifestories2.png"
        text: "In the two years since Adriana D. Hughes graduated with her degree </br> in communication and history,she had worked at a beach club in Annapolis, as a substitute
               </br> teacher in McLean, Va., and as a sales associate at a store in Baltimore. Adriana was ready to give up her search </br> for a position in Public Relations until she learned about Mepedia. Adriana used the Mepedia
							 </br> platform to showcase her creativity and work with social media. She was hired to </br> do Public Relations at one of the world's largest technology company."
      }
      {
        image: "/assets/home-real-lifestories1.png"
        text: "Getting the right people into the right jobs is key to our company's growth. </br>
              I was inundated with resumes every day for the business development position that is critical to my startup's growth. </br>
              I was looking for someone that could lead, collaborate, multi task and present to customers and grow our business. </br>
              Mepedia platform helped me with the best matches for my criteria and saved me a lot of time and energy. </br>
              It was great to finally find someone that I could trust. </br> Ron Y. Murphy"
      }
    ]

    login = (user) ->
      sessionService.login(user.email, user.password).then(
        (resp) ->
          $state.go "main.signup_#{resp.type.toLowerCase()}.personal", null, {reload: true}
      ).catch(
        (errors) ->
          console.log(errors)
      )

    getType = ->
      if $scope.candidate then Candidate.className else Employer.className

    init()
])