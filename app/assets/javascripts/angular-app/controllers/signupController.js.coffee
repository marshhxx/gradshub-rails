angular.module('mepedia.controllers').controller("signupController", [
	'$scope',
	($scope)->
		$scope.today = ->
			$scope.dt = new Date()
			return

		$scope.today()
		$scope.clear = ->
			$scope.date = null
			return

		$scope.open = ($event) ->
			$event.preventDefault()
			$event.stopPropagation()
			$scope.opened = true
			return

		$scope.dateOptions =
			formatYear: "yy"
			startingDay: 1

])