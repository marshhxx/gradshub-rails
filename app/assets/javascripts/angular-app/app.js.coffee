@app = angular.module("gradshub-ng",
  ["ui.router", "templates", "gradshub-ng.config", "gradshub-ng.services", "gradshub-ng.controllers", "ngSanitize", 'ngMessages',
   'angulartics', 'angulartics.google.analytics'])
.config ($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider, $analyticsProvider) ->
#	$httpProvider.defaults.withCredentials = true;
#	$httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  $httpProvider.interceptors.push('authInterceptor')
  $httpProvider.interceptors.push('errorInterceptor')
  $httpProvider.defaults.headers.common.Accept = 'application/mepedia.v1'
  $httpProvider.defaults.headers.common['Content-type'] = 'application/json'
  $urlRouterProvider.otherwise "/home"
  $stateProvider.state("main", {
    abstract: true,
    templateUrl: "angular-app/templates/layouts/mainLayout.html",
    controller: "mainController",
    data: {
      navOptions: {
      }
    }
  }).state("main.page", {
    url: "/home",
    templateUrl: "angular-app/templates/home.html",
    controller: "HomeController",
    data: {
      navOptions: {
        home: true
      }
    }
  }).state("main.login", {
    url: "/login",
    templateUrl: "angular-app/templates/login.html",
    controller: "loginController",
  }).state("main.forgotpssw", {
    abstract: true,
    templateUrl: "angular-app/templates/views/forgot_pssw.html",
  }).state("main.forgotpssw.email", {
    url: "/forgotpssw",
    templateUrl: "angular-app/templates/views/forgot/email.html",
    controller: "forgotPasswordController",
  }).state("main.forgotpssw.checkemail", {
    url: "/checkemail",
    templateUrl: "angular-app/templates/views/forgot/checkemail.html",
    controller: "forgotPasswordController",
  }).state("main.forgotpssw.resetpssw", {
    url: "/resetpssw?r={resource}&reset_token={token}",
    templateUrl: "angular-app/templates/views/forgot/reset.html",
    controller: "forgotPasswordController",
  }).state("main.forgotpssw.resetsccss", {
    url: "/resetsccss",
    templateUrl: "angular-app/templates/views/forgot/success.html",
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
  }).state("main.user_settings", {
    url: "/settings",
    templateUrl: "angular-app/templates/settings.html",
    controller: "settingsController"
  }).state("main.privacy", {
    url: "/privacy",
    templateUrl: "angular-app/templates/privacy.html"
  }).state("main.terms", {
    url: "/terms",
    templateUrl: "angular-app/templates/terms.html"
  })
.run (initializeApp) ->
  initializeApp.initialize()

  return

