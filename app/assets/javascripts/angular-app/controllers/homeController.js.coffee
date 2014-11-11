angular.module('mepedia.controllers').controller("HomeController", [
	'$scope', 'User', '$state', '$anchorScroll', '$location', 'sessionService', '$sce',
	($scope, User, $state, $anchorScroll, $location, sessionService, $sce)->
		console.log 'ExampleCtrl running'
		$scope.exampleValue = "Hello angular-app and rails"

		$scope.renderHtml = (htmlCode) ->
		 $sce.trustAsHtml(htmlCode)

		$scope.registerUser = () ->
			user = new User()
			user.name = $scope.name
			user.lastname = $scope.lastname
			user.email = $scope.email
			user.password = $scope.password
			user.$save {}, (()->
				sessionService.login($scope.email, $scope.password)
				return
			), (error)->
				console.log error
			return

		$scope.carouselInterval = 4000
		$scope.slides = [
			{
				image: "/assets/background-l0.jpg"
			}
			{
				image: "/assets/background-l1.jpg"
			}
			{
				image: "/assets/background-l2.jpg"
			}
			{
				image: "/assets/background-l3.jpg"
			}
		]

		$scope.rlslides = [
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

		$scope.type = true
		$scope.showType = ->
			$scope.type = not $scope.type

		$scope.gotoTop = ->
			# set the location.hash to the id of
			# the element you wish to scroll to.
			$location.hash "top"
			$anchorScroll()

])