@app = angular.module("mepedia",
  ["ui.router", "templates", "mepedia.config", "mepedia.services", "mepedia.controllers", "ngSanitize", 'ngMessages',
   'angulartics', 'angulartics.google.analytics'])
.config ($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider, $analyticsProvider) ->
#	$httpProvider.defaults.withCredentials = true;
#	$httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
#	$httpProvider.interceptors.push('errorInterceptor')
  $httpProvider.defaults.headers.common.Accept = 'application/mepedia.v1'
  $httpProvider.defaults.headers.common['Content-type'] = 'application/json'
  $urlRouterProvider.otherwise "/home"
  $stateProvider.state("home", {
    abstract: true,
    templateUrl: "angular-app/templates/layouts/homeLayout.html",
    controller: "mainController",
  }).state("main", {
    abstract: true,
    templateUrl: "angular-app/templates/layouts/mainLayout.html",
    controller: "mainController",
  }).state("home.page", {
    url: "/home",
    templateUrl: "angular-app/templates/home.html",
    controller: "HomeController",
  }).state("home.login", {
    url: "/login",
    templateUrl: "angular-app/templates/login.html",
    controller: "loginController",
  }).state("home.forgotpssw", {
    url: "/forgotpssw",
    templateUrl: "angular-app/templates/views/forgot_pssw.html",
    controller: "forgotPasswordController",
  }).state("home.checkemail", {
    url: "/checkemail",
    templateUrl: "angular-app/templates/views/forgot_pssw_checkemail.html",
    controller: "forgotPasswordController",
  }).state("home.resetpssw", {
    url: "/resetpssw?r={resource}&reset_token={token}",
    templateUrl: "angular-app/templates/views/forgot_pssw_reset.html",
    controller: "forgotPasswordController",
  }).state("resetsccss", {
    url: "/resetsccss",
    templateUrl: "angular-app/templates/views/forgot_pssw_success.html",
    controller: "forgotPasswordController",
  }).state("main.signup_candidate", {
    url: "/signup",
    templateUrl: "angular-app/templates/signup.html",
    controller: "candidateSignupController",
  }).state("main.signup_employer", {
    url: "/signup",
    templateUrl: "angular-app/templates/signup.html",
    controller: "employerSignupController",
  }).state("main.signup_candidate.personal", {
    url: "/personal",
    templateUrl: "angular-app/templates/views/form-personal.html",
  }).state("main.signup_candidate.education", {
    url: "/education",
    templateUrl: "angular-app/templates/views/form-education.html",
  }).state("main.signup_candidate.interests", {
    url: "/interests",
    templateUrl: "angular-app/templates/views/form-interests.html",
  }).state("main.signup_employer.personal", {
    url: "/info",
    templateUrl: "angular-app/templates/views/form-personal.html",
  }).state("main.signup_employer.company", {
    url: "/company",
    templateUrl: "angular-app/templates/views/form-company.html",
  }).state("main.signup_employer.looking", {
    url: "/looking",
    templateUrl: "angular-app/templates/views/form-lookingfor.html",
  }).state("main.candidate_profile", {
    url: "/candidate/:uid",
    templateUrl: "angular-app/templates/candidate_profile.html",
    controller: "candidateProfileController",
  }).state("main.employer_profile", {
    url: "/employer/:uid",
    templateUrl: "angular-app/templates/employer_profile.html",
    controller: "employerProfileController",
  }).state("main.search", {
    url: "/search/:keyword",
    templateUrl: "angular-app/templates/search.html",
    controller: "searchController",
  })

  return

