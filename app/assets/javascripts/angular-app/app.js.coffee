angular.module("mepedia", ["ui.router", "templates"]).config ($stateProvider, $urlRouterProvider) ->
	$urlRouterProvider.otherwise "/"
	$stateProvider.state("home",
		url: "/"
		templateUrl: "angular-app/templates/home.html"
		controller: "HomeController"
	).state "about", {}
	return

