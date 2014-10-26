@app = angular.module("mepedia", [
	 'ngRoute'
]).config ($routeProvider, $locationProvider) ->
	$routeProvider.when "/",
		templateUrl: "home.html"
		controller: "HomeController"

	$locationProvider.html5Mode true

