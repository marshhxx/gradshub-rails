@app = angular.module("mepedia",
	["ui.router", "templates", "mepedia.services", "mepedia.controllers", "ngResource", "ui.bootstrap"])
.config ($stateProvider, $urlRouterProvider, $httpProvider) ->
	$httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
	$httpProvider.defaults.headers.common.Accept = 'application/mepedia.v1'
	$httpProvider.defaults.headers.common['Content-type'] = 'application/json'
	interceptor = [
		"$location"
		"$rootScope"
		"$q"
		($location, $rootScope, $q) ->
			success = (response) ->
				response
			error = (response) ->
				if response.status is 401
					$rootScope.$broadcast "event:unauthorized"
					$location.path "/login"
					return response
				$q.reject response
			return (promise) ->
				promise.then success, error
	]
	$httpProvider.interceptors.push interceptor
	$urlRouterProvider.otherwise "/"
	$stateProvider.state("home",
		url: "/"
		templateUrl: "angular-app/templates/home.html"
		controller: "HomeController"
	).state("login",
		url: "/login"
		templateUrl: "angular-app/templates/login.html"
		controller: "loginController"
	).state("profile",
		url: "/profile"
		templateUrl: "angular-app/templates/profile.html"
		controller: "profileController"
	)
	return

