angular
.module('mepedia.controllers')
.controller("employerSignupController",
	['$scope', '$q', '$http', '$state', '$log', 'Country', 'State', 'Nationality', 'sessionService', 'Skill', 'Employer','Interest', 'EmployerNationalities', 'Company', 'EmployerCompany', 'EmployerSkills', 'Utils'
		($scope, $q, $httpProvider, $state, $log, Country, State, Nationality, sessionService, Skill, Employer, Interest, EmployerNationalities, Company, EmployerCompany, EmployerSkills, Utils)->

			init = ->
				$scope.selectedTags = []
				$scope.selectedSkills = [];
				$scope.cSubmitted = false
				$scope.pSubmitted = false
				$scope.skills = new EmployerSkills()
				$scope.employerCompany = new EmployerCompany()

				$scope.selectedFrom = "From"
				$scope.selectedTo = "To"

				countries = Country.query (countries)->
					$scope.countries = countries.countries

				companies = Company.query (companies) ->
					$scope.companies = companies.companies

				$scope.getStateByCountryId = (countryId) ->
					states = State.get {country_id: countryId}, ->
						$scope.states = states.states

				nationalities = Nationality.query (nationalities) ->
					$scope.nationalities = nationalities.nationalities

				$scope.onCountry = (country) ->
					if(country?)
						$scope.user.country_id = country.id
						$scope.getStateByCountryId(country.id)

				$scope.onState = (state) ->
					if(state?)
						$scope.user.state_id = state.id

				$scope.onNationality = (nationality) ->
					if(nationality?)
						$scope.employerNationality = new EmployerNationalities();
						$scope.employerNationality.name = nationality.name
						$scope.employerNationality.emloyer_id = $scope.user.uid;

				$scope.onCompany = (company) ->
					if company?
						$scope.company = new Company()


				####### Skills ######
				skills = Skill.get ->
					$scope.skillsTags = skills.skills

				sessionService.requestCurrentUser().then(
					(user) ->
						$state.go 'home.page' if !user?
						$scope.user = Utils.employerFromObject(user.employer)
						$scope.employerCompany.employer_id = $scope.user.uid
						$scope.skills.employer_id = $scope.user.uid
				,
					(error) ->
						console.log error
						$state.go 'home.page'
				)

				$scope.validatePersonal = (valid) ->
					$scope.pSubmitted = true
					$state.go 'main.signup_employer.company' if valid

				$scope.validateCompany = (valid) ->
					$scope.eSubmitted = true
					$state.go 'main.signup_employer.looking' if valid

				$scope.validateAndCreate = validateAndCreate

			validateAndCreate = (valid) ->
				createUser() if valid

			createUser = () ->
				$httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()
				$q.all([saveEmployerNationality(), saveCompany(), saveSkills(), saveUser()])
				.then(
					(data) ->
						console.log(data)
						$state.go 'main.employer_profile'
				,
					(error) ->
						console.log error
				)

			saveCompany = ->
				$scope.company.$save()

			saveEmployerNationality = ->
				$scope.employerNationality.$save()

			saveSkills = ->
				$scope.skills.skills = [{name: skill.name} for skill in $scope.selectedSkills]
				$scope.skills.$update()

			saveUser = ->
				$scope.user.$update()

			init()
	])