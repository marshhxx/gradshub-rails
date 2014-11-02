angular.module('mepedia.controllers').controller("HomeController", [
	'$scope', 'User', '$state'
	($scope, User, $state)->
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
])