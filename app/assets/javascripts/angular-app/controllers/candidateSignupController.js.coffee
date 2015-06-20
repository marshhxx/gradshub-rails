angular
.module('mepedia.controllers')
.controller("candidateSignupController",
  ['$scope', '$rootScope', '$q', '$http', '$state', 'sessionService', 'Skill', 'Candidate', 'Interest',
   'CandidateNationalities', 'Education', 'CandidateSkills', 'Utils', 'alertService',
    ($scope, $rootScope, $q, $httpProvider, $state, sessionService, Skill, Candidate, Interest, CandidateNationalities,
     Education, CandidateSkills, Utils, alertService)->
      init = ->
        $state.go 'main.signup_candidate.personal'
        $scope.selectedTags = []
        $scope.education = new Education()
        $scope.skills = new CandidateSkills()
        $scope.candidateNationality = new CandidateNationalities();

        $scope.genders = [
          "Male",
          "Female",
          "Other"
        ]

        $scope.userGender = "Select Gender"
        $scope.selectedFrom = "From"
        $scope.selectedTo = "To"

        $scope.onGender = (index) ->
          $scope.user.gender = index
          $scope.gender = $scope.userGender = $scope.genders[index]

        $scope.onCountry = (country) ->
          $scope.user.country_id = country.id if country?

        $scope.onState = (state) ->
          $scope.user.state_id = state.id if state?

        $scope.onNationality = (nationality) ->
          $scope.candidateNationality.nationality_id = nationality.id if nationality?

        ####### Eduaction ######

        $scope.onSchool = (school) ->
          $scope.education.school_id = school.id if school?

        $scope.onSchoolCountry = (country) ->
          $scope.education.country_id = country.id if country?

        $scope.onSchoolState = (state) ->
          $scope.education.state_id = state.id if state?

        $scope.onMajor = (major) ->
          $scope.education.major_id = major.id if major?

        $scope.onDegree = (degree) ->
          $scope.education.degree_id = degree.id if degree?

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

        $scope.$on '$viewContentLoaded', (event) ->
          angular.element('#switchEducationSignup').bootstrapSwitch state: $scope.isCurrentEducation

          angular.element('#switchEducationSignup').on 'switchChange.bootstrapSwitch', (event, state) ->
            if state then ($scope.isCurrentEducation = true) else ($scope.isCurrentEducation = false)
            $scope.$apply()
            return

        dateValidation()
        initUser()

      initUser = ->
        $scope.userPromise.then(
          (user) ->
            $scope.user = Utils.candidateFromObject(user.candidate)
            $scope.education.candidate_id = $scope.user.uid
            $scope.skills.candidate_id = $scope.user.uid
            $scope.candidateNationality.candidate_id = $scope.user.uid
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
        $scope.candidateNationality.$save()

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
            $scope.innerScope.educationForm.$setValidity('validDates', valid) if $scope.innerScope && scope.innerScope.educationForm
        )

      $scope.isCurrentEducation = true

      init()
  ])