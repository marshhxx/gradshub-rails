angular
.module('gradshub-ng.controllers')
.controller("candidateSignupController",
  ['$scope', '$rootScope', '$q', '$http', '$state', 'sessionService', 'Candidate',
   'CandidateNationalities', 'Education', 'Utils', 'alertService',
    ($scope, $rootScope, $q, $httpProvider, $state, sessionService, Candidate, CandidateNationalities,
     Education, Utils, alertService)->
      init = ->
        $scope.user = {} # init user because some of the input requires it.
        $scope.selectedTags = []
        $scope.education = new Education()
        $scope.candidateNationality = new CandidateNationalities();

        $scope.genders = [
          "Male",
          "Female",
          "Other"
        ]

        $scope.onCountry = (country) ->
          $scope.user.country_id = country.id if country?

        $scope.onState = (state) ->
          $scope.user.state_id = state.id if state?

        $scope.onNationality = (nationality) ->
          $scope.candidateNationality.nationality_id = nationality.id if nationality?

        ####### Education ######

        $scope.onSchool = (school) ->
          if school?
            if Utils.isObject(school)
              $scope.education.school_id = school.id
            else
              $scope.education.other_school = school

        $scope.onSchoolCountry = (country) ->
          $scope.education.country_id = country.id if country?

        $scope.onSchoolState = (state) ->
          $scope.education.state_id = state.id if state?

        $scope.onMajor = (major) ->
          if major?
            if Utils.isObject(major)
              $scope.education.major_id = major.id
            else
              $scope.education.other_major = major

        $scope.onDegree = (degree) ->
          if degree?
            if Utils.isObject(degree)
              $scope.education.degree_id = degree.id
            else
              $scope.education.other_degree = degree

        $scope.validatePersonal = (valid) ->
          $state.go 'main.signup_candidate.education' if valid

        $scope.backToPersonal = ->
          $state.go 'main.signup_candidate.personal'

        $scope.backToEducation = ->
          $state.go 'main.signup_candidate.education'

        $scope.validateAndCreate = validateAndCreate

        $scope.setInnerScope = (scope) -> $scope.innerScope = scope

        $scope.$state = $state

        initUser()

      initUser = ->
        $scope.userPromise.then(
          (user) ->
            $scope.user = Utils.candidateFromObject(user.candidate)
            $scope.education.candidate_id = $scope.user.uid
            $scope.candidateNationality.candidate_id = $scope.user.uid
            # Change default gender
            $scope.user.gender = ''
        )
        $scope.education.education_date = ''

      validateAndCreate = (valid) ->
        createUser() if valid

      createUser = () ->
        $q.all([saveCandidateNationality(), saveEducation(), saveUser()]).then(
          (data) ->
            $state.go 'main.candidate_profile', {uid: 'me'}, { reload: true }
        ).catch(alertService.defaultErrorCallback)

      saveEducation = ->
        $scope.education.$save()

      saveCandidateNationality = ->
        $scope.candidateNationality.$save() if $scope.candidateNationality.nationality_id

      saveUser = ->
        $scope.user.$update()

      init()
  ])