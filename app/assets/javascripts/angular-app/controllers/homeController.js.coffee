angular.module('mepedia.controllers').controller("HomeController", [
	'$http','$scope', 'Candidate', 'Employer', '$state', '$anchorScroll', '$location', 'sessionService', '$sce', '$stateParams', 'registerService', 'alertService',
	($http, $scope, Candidate, Employer, $state, $anchorScroll, $location, sessionService, $sce, $stateParams, registerService, alertService)->
		if sessionService.isAuthenticated()
			if sessionService.sessionType() == "Candidate"
				$state.go 'main.candidate_profile'
			else
				$state.go 'main.employer_profile'

		init = ->
			$scope.renderHtml = (htmlCode) -> $sce.trustAsHtml(htmlCode)
			$scope.candidate = true
			$scope.isCandidate = () -> $scope.candidate = true
			$scope.isEmployer = () -> $scope.candidate = false
			$scope.carouselInterval = 4000
			$scope.slides = slides
			$scope.rlslides = rlslides
			$scope.type = true
			$scope.showType = ->
				$scope.type = not $scope.type
			$scope.gotoTop = ->
				# set the location.hash to the id of
				# the element you wish to scroll to.
				$location.hash "top"
				$anchorScroll()

			$scope.loginOnePgr = loginOnePgr

			$scope.registerUser = registerUser

		registerUser = (isValid) ->
			if isValid
				if $scope.candidate
					user = new Candidate()
				else
					user = new Employer()
				user.name = $scope.name
				user.lastname = $scope.lastname
				user.email = $scope.email
				user.password = $scope.password
				registerService.register(user).then(
					(payload) ->
						login(registerService.currentUser())
				,
					(response)->
						error = response.data.error
						if error.code == "ERR02"
							$state.go 'main.login_onepgr', {mail: user.email}
				)
			else
				$scope.submitted = true

		slides = [
			{
				image: "/assets/background-marqui1.png"
			}
			{
				image: "/assets/background-luli1.png"
			}
			{
				image: "/assets/background-nico1.png"
    }
			{
				image: "/assets/background-mumi1.png"
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

########  OnePgr login #########
		$scope.onepgr_email = $stateParams.mail
		loginOnePgr = () ->
			user = registerService.currentUser()
			user.onepgr_password = $scope.password
			registerService.register(user).then(
				() ->
					login(registerService.currentUser())
				,
				(response) ->
					console.log(response.data.error)
			)

		login = (user) ->
			promise = sessionService.login(user.email, user.password)
			promise.then(
				(resp) ->

					$state.go 'main.signup_candidate.personal' if resp.type == 'Candidate'
					$state.go 'main.signup_employer.personal' if resp.type == 'Employer'
			,
				(errors) ->
					console.log(errors)
			)

		init()
])