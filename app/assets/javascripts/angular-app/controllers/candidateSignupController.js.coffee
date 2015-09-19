angular
.module('gradshub-ng.controllers')
.controller("candidateSignupController",
  ['$scope', '$rootScope', '$q', '$http', '$state', 'sessionService', 'Skill', 'Candidate', 'Interest',
   'CandidateNationalities', 'Education', 'CandidateSkills', 'Utils', 'alertService',
    ($scope, $rootScope, $q, $httpProvider, $state, sessionService, Skill, Candidate, Interest, CandidateNationalities,
     Education, CandidateSkills, Utils, alertService)->
      init = ->
        $scope.user = {} # init user because some of the input requires it.
        $scope.selectedTags = []
        $scope.education = new Education()
        $scope.skills = new CandidateSkills()
        $scope.candidateNationality = new CandidateNationalities();

        $scope.genders = [
          "Male",
          "Female",
          "Other"
        ]

        $scope.selectedFrom = "From"
        $scope.selectedTo = "To"

        $scope.onCountry = (country) ->
          $scope.user.country_id = country.id if country?

        $scope.onState = (state) ->
          $scope.user.state_id = state.id if state?

        $scope.onNationality = (nationality) ->
          $scope.candidateNationality.nationality_id = nationality.id if nationality?

        ####### Eduaction ######

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

        ####### Skills ######
        Skill.query (skills) ->
          $scope.skillsTags = skills.skills

        $scope.selectedSkills = [];

        $scope.validatePersonal = (valid) ->
          $state.go 'main.signup_candidate.education' if valid

        $scope.validateEducation = (valid) ->
          $state.go 'main.signup_candidate.interests' if valid

        $scope.backToPersonal = ->
          $state.go 'main.signup_candidate.personal'

        $scope.backToEducation = ->
          $state.go 'main.signup_candidate.education'

        $scope.validateAndCreate = validateAndCreate

        $scope.setInnerScope = (scope) -> $scope.innerScope = scope

        $scope.$state = $state

        dateValidation()
        initUser()

      initUser = ->
        $scope.userPromise.then(
          (user) ->
            $scope.user = Utils.candidateFromObject(user.candidate)
            $scope.education.candidate_id = $scope.user.uid
            $scope.skills.candidate_id = $scope.user.uid
            $scope.candidateNationality.candidate_id = $scope.user.uid
            # change default gender
            $scope.user.gender = ''
        )

      validateAndCreate = (valid) ->
        createUser() if valid

      createUser = () ->
        $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()
        $q.all([saveCandidateNationality(), saveEducation(), saveSkills(), saveUser()]).then(
          (data) ->
            $state.go 'main.candidate_profile', {uid: 'me'}, { reload: true }
        ).catch(alertService.defaultErrorCallback)

      saveEducation = ->
        $scope.education.$save()

      saveCandidateNationality = ->
        $scope.candidateNationality.$save() if $scope.candidateNationality.nationality_id

      saveSkills = ->
        $scope.skills.skills = $scope.selectedSkills.map((skill) -> {name: skill})
        $scope.skills.$update()

      saveUser = ->
        $scope.user.$update()

      dateValidation = ->
        $scope.$watchGroup(
          ['education.start_date', 'education.end_date'],
          ->
            valid = Date.parse($scope.education.end_date) >= Date.parse($scope.education.start_date)
            valid = !$scope.education.end_date? || valid
            $scope.innerScope.educationForm.$setValidity('validDates', valid) if $scope.innerScope && $scope.innerScope.educationForm
        )

      init()
  ])