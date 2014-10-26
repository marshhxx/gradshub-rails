angular.module('mepedia').controller("HomeController", [
	'$scope',
	($scope)->
		console.log 'ExampleCtrl running'

		$scope.exampleValue = "Hello angular-app and rails"

])