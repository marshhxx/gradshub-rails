@app = angular.module("mepedia",
	["ui.router", "templates", "mepedia.services", "mepedia.controllers", "ngSanitize", 'ngMessages', 'ngAnimate'])
.config ($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider) ->
#	$httpProvider.defaults.withCredentials = true;
#	$httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
#	$httpProvider.interceptors.push('errorInterceptor')

	$httpProvider.defaults.headers.common.Accept = 'application/mepedia.v1'
	$httpProvider.defaults.headers.common['Content-type'] = 'application/json'
	$urlRouterProvider.otherwise "/home/page"
	$urlRouterProvider.when('/main','/home/page')
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
		controller: "mainController"
	).state("main.login_onepgr",
		url: "/login?mail"
		templateUrl: "angular-app/templates/views/login_onepgr.html"
		controller: "HomeController"
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
	).state("main.signup_candidate.personal",
		url: "/personal"
		templateUrl: "angular-app/templates/views/form-personal.html"
	).state("main.signup_candidate.education",
		url: "/education"
		templateUrl: "angular-app/templates/views/form-education.html"
	).state("main.signup_candidate.interests",
		url: "/interests"
		templateUrl: "angular-app/templates/views/form-interests.html"
	).state("main.signup_employer.personal",
		url: "/personal"
		templateUrl: "angular-app/templates/views/form-personal.html"
	).state("main.signup_employer.company",
		url: "/company"
		templateUrl: "angular-app/templates/views/form-company.html"
	).state("main.signup_employer.looking",
		url: "/looking"
		templateUrl: "angular-app/templates/views/form-lookingfor.html"
	).state("main.signup_candidate",
		url: "/signup/candidate"
		templateUrl: "angular-app/templates/signup.html"
		controller: "candidateSignupController"
	).state("main.signup_employer",
		url: "/signup/employer"
		templateUrl: "angular-app/templates/signup.html"
		controller: "employerSignupController"
	).state("main.candidate_profile",
		url: "/candidate/profile"
		templateUrl: "angular-app/templates/candidate_profile.html"
		controller: "candidateProfileController"
	).state("main.employer_profile",
		url: "/employer/profile"
		templateUrl: "angular-app/templates/employer_profile.html"
		controller: "employerProfileController"
	)

	return

