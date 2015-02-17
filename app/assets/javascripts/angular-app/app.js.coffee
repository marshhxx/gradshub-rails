@app = angular.module("mepedia",
	["ui.router", "templates", "mepedia.services", "mepedia.controllers", "ngSanitize"])
.config ($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider) ->
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
	$urlRouterProvider.otherwise "/main/profile"
	$urlRouterProvider.when('/main', '/main/profile')
	$stateProvider.state("home",
		url: "/home"
		templateUrl: "angular-app/templates/layouts/homeLayout.html"
		controller: "HomeController"
	).state("home.page",
		url: "/page"
		templateUrl: "angular-app/templates/home.html"
		controller: "HomeController"
	).state("login",
			url: "/login"
			templateUrl: "angular-app/templates/login.html"
			controller: "loginController"
	).state("main",
		url: "/main"
		templateUrl: "angular-app/templates/layouts/mainLayout.html"
#		controller: "signupController"
	).state("main.forgotpssw",
		url: "/forgotpssw"
		templateUrl: "angular-app/templates/views/forgot_pssw.html"
		controller: "forgotPasswordController"
	).state("main.checkemail",
		url: "/checkemail"
		templateUrl: "angular-app/templates/views/forgot_pssw_checkemail.html"
		controller: "forgotPasswordController"
	).state("main.resetpssw",
		url: "/resetpssw?r={resource}&reset_token={token}"
		templateUrl: "angular-app/templates/views/forgot_pssw_reset.html"
		controller: "forgotPasswordController"
	).state("main.resetsccss",
		url: "/resetsccss"
		templateUrl: "angular-app/templates/views/forgot_pssw_success.html"
		controller: "forgotPasswordController "
	).state("main.signup",
		url: "/signup"
		templateUrl: "angular-app/templates/signup.html"
		controller: "signupController"
	).state("main.signup.personal",
		url: "/personal"
		templateUrl: "angular-app/templates/views/form-personal.html"
	).state("main.signup.education",
		url: "/education"
		templateUrl: "angular-app/templates/views/form-education.html"
	).state("main.signup.career",
		url: "/career"
		templateUrl: "angular-app/templates/views/form-interests.html"
	).state("main.signup.company",
		url: "/company"
		templateUrl: "angular-app/templates/views/form-company.html"
	).state("main.signup.interests",
		url: "/interests"
		templateUrl: "angular-app/templates/views/form-lookingfor.html"
	).state("main.profile",
		url: "/profile"
		templateUrl: "angular-app/templates/profile.html"
		controller: "profileController"
	)

	return

