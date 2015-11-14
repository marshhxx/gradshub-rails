angular
.module('gradshub-ng.controllers')
.controller("employerSignupController",
  ['$scope', '$q', '$http', '$state', 'sessionService', 'Skill', 'Employer', 'Interest', 'EmployerNationalities',
   'Company', 'EmployerCompany', 'EmployerSkills', 'EmployerInterests', 'Utils', 'alertService'
    ($scope, $q, $httpProvider, $state, sessionService, Skill, Employer, Interest, EmployerNationalities,
     Company, EmployerCompany, EmployerSkills, EmployerInterests, Utils, alertService) ->
      init = ->
        $scope.user = {} # init user because some of the input requires it.
        $state.go 'main.signup_employer.personal'
        $scope.selectedInterests = []
        $scope.selectedSkills = []
        $scope.addCompanyEnabled = false
        $scope.skills = new EmployerSkills()
        $scope.interests = new EmployerInterests();
        $scope.employerCompany = new EmployerCompany()
        $scope.employerNationality = new EmployerNationalities();

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
          $scope.employerNationality.nationality_id = nationality.id if nationality?

        $scope.onCompany = (company) ->
          $scope.employerCompany.company_id = company.id if company?

        $scope.onCompanyCountry = (country) ->
          $scope.employerCompany.country_id = country.id if country?

        $scope.onCompanyState = (state) ->
          $scope.employerCompany.state_id = state.id if state?

        ####### Skills ######
        Skill.query (skills)->
          $scope.skillsTags = skills.skills

        Interest.query (interests) ->
          $scope.interestsTags = interests.interests

        $scope.$state = $state

        $scope.validatePersonal = (valid) ->
          $state.go 'main.signup_employer.company' if valid

        $scope.backToPersonal = ->
          $state.go 'main.signup_employer.personal'

        $scope.backToCompany = ->
          $state.go 'main.signup_employer.company'

        $scope.validateAndCreate = validateAndCreate

        initUser()

      initUser = ->
        $scope.userPromise.then(
          (user) ->
            $scope.user = Utils.employerFromObject(user.employer)
            $scope.employerCompany.employer_id = $scope.user.uid
            $scope.skills.employer_id = $scope.user.uid
            $scope.interests.employer_id = $scope.user.uid
            $scope.employerNationality.employer_id = $scope.user.uid
            # change default gender
            $scope.user.gender = ''
        )

      validateAndCreate = (valid) ->
        createUser() if valid

      createUser = () ->
        $q.all([saveEmployerNationality(), saveSkills(), saveInterests(), saveUser()])
          .then((data) -> $state.go 'main.employer_profile', {uid: 'me'}, { reload: true})
          .catch(alertService.defaultErrorCallback)

      createCompany = ->
        deferred = $q.defer()
        deferred.promise

      saveCompany = (id) ->
        $scope.employerCompany.company_id = id
        $scope.employerCompany.$save()

      saveEmployerNationality = ->
        $scope.employerNationality.$save() if $scope.employerNationality.nationality_id

      saveSkills = ->
        $scope.skills.skills = $scope.selectedSkills.map((skill) -> {name: skill})
        $scope.skills.$update()

      saveInterests = ->
        $scope.interests.interests = $scope.selectedInterests.map((interest) -> {name: interest})
        $scope.interests.$update()

      saveUser = ->
        $scope.user.$update()

      init()
  ])