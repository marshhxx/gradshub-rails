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
    data: {
      navOptions: {
        login: true
      }
    }
  }).state("main.forgotpssw", {
    abstract: true,
    templateUrl: "angular-app/templates/views/forgot/forgot_pssw.html",
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
    parent: 'main.signup_candidate',
    views: {
      'form': {
        templateUrl: 'angular-app/templates/views/signup/personal/personal-form.html'
      },
      'img': {
        templateUrl: 'angular-app/templates/views/signup/personal/personal-img.html',
      }
    }
  }).state("main.signup_candidate.education", {
    url: "/education",
    views: {
      'form': {
        templateUrl: 'angular-app/templates/views/signup/education/education-form.html'
      },
      'img': {
        templateUrl: 'angular-app/templates/views/signup/education/education-img.html',
      }
    }
  }).state("main.signup_employer.personal", {
    url: "/info",
    views: {
      'form': {
        templateUrl: 'angular-app/templates/views/signup/personal/personal-form.html'
      },
      'img': {
        templateUrl: 'angular-app/templates/views/signup/personal/personal-img.html',
      }
    }
  }).state("main.signup_employer.company", {
    url: "/company",
    views: {
      'form': {
        templateUrl: 'angular-app/templates/views/signup/company/company-form.html'
      },
      'img': {
        templateUrl: 'angular-app/templates/views/signup/company/company-img.html',
      }
    }
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
  }).state("main.about", {
    url: "/about",
    templateUrl: "angular-app/templates/about.html"
  }).state("main.terms", {
    url: "/terms",
    templateUrl: "angular-app/templates/terms_privacy.html"
  })
.run (initializeApp) ->
  initializeApp.initialize()

  return

