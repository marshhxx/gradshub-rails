angular.module('mepedia.controllers').controller("HomeController", [
	'$scope', 'User', '$state', '$anchorScroll', '$location'
	($scope, User, $state, $anchorScroll, $location)->
		console.log 'ExampleCtrl running'
		$scope.exampleValue = "Hello angular-app and rails"

		$scope.registerUser = () ->
			user = new User()
			user.name = $scope.name
			user.lastname = $scope.lastname
			user.email = $scope.email
			user.password = $scope.password
			user.$save (->
				console.log "Yes"
				$state.go 'profile'
				return
			), ->
			console.log "No"
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

		$scope.type = true
		$scope.showType = ->
			$scope.type = not $scope.type

		$scope.gotoTop = ->
			# set the location.hash to the id of
			# the element you wish to scroll to.
			$location.hash "top"
			# call $anchorScroll()
			$anchorScroll()

])