angular
.module('mepedia.controllers')
.controller("candidateSignupController",
  ['$scope', '$rootScope', '$q', '$http', '$state', 'sessionService', 'Skill', 'Candidate', 'Interest',
   'CandidateNationalities', 'Education', 'CandidateSkills', 'Utils', 'alertService',
    ($scope, $rootScope, $q, $httpProvider, $state, sessionService, Skill, Candidate, Interest, CandidateNationalities,
     Education, CandidateSkills, Utils, alertService)->
      init = ->
#        $state.go 'main.signup_candidate.personal'
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
          if(country?)
            $scope.country = country
            $scope.user.country_id = country.id

        $scope.onState = (state) ->
          if(state?)
            $scope.state = state
            $scope.user.state_id = state.id

        $scope.onNationality = (nationality) ->
          if(nationality?)
            $scope.nationality = nationality
            $scope.candidateNationality.nationality_id = nationality.id
            $scope.candidateNationality.candidate_id = $scope.user.uid;

        ####### Eduaction ######

        $scope.onSchool = (school) ->
          if(school?)
            $scope.school = school
            $scope.education.school_id = school.id

        $scope.onSchoolCountry = (country) ->
          if(country?)
            $scope.schoolCountry = country
            $scope.education.country_id = country.id

        $scope.onSchoolState = (state) ->
          if(state?)
            $scope.schoolState = state
            $scope.education.state_id = state.id

        $scope.onMajor = (major) ->
          if(major?)
            $scope.major = major
            $scope.education.major_id = major.id

        $scope.onDegree = (degree) ->
          if(degree?)
            $scope.degree = degree
            $scope.education.degree_id = degree.id

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
        sessionService.requestCurrentUser().then(
          (user) ->
            $state.go 'home.page' if !user?
            $scope.user = Utils.candidateFromObject(user.candidate)
            $scope.education.candidate_id = $scope.user.uid
            $scope.skills.candidate_id = $scope.user.uid
            $scope.candidateNationality.candidate_id = $scope.user.uid
        ).catch(
          (error) ->
            console.log error
            $state.go 'home.page'
        )

      validateAndCreate = (valid) ->
        createUser() if valid

      createUser = () ->
        $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()
        $q.all([saveCandidateNationality(), saveEducation(), saveSkills(), saveUser()]).then(
          (data) ->
            console.log(data)
            $state.go 'main.candidate_profile'
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
            $scope.innerScope.educationForm.$setValidity('validDates', valid) if $scope.innerScope
        )

      $scope.isCurrentEducation = true

      init()
  ])