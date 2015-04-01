angular
.module('mepedia.controllers')
.controller("employerSignupController",
	['$scope', '$q', '$http', '$state', '$log', 'Country', 'State', 'Nationality', 'sessionService', 'Skill', 'Employer','Interest', 'EmployerNationalities', 'Company', 'EmployerCompany', 'EmployerSkills', 'EmployerInterests', 'Utils'
		($scope, $q, $httpProvider, $state, $log, Country, State, Nationality, sessionService, Skill, Employer, Interest, EmployerNationalities, Company, EmployerCompany, EmployerSkills, EmployerInterests, Utils) ->

			init = ->
				$scope.selectedInterests = []
				$scope.selectedSkills = []
				$scope.cSubmitted = false
				$scope.pSubmitted = false
				$scope.skills = new EmployerSkills()
				$scope.interests = new EmployerInterests();
				$scope.employerCompany = new EmployerCompany()

				$scope.selectedFrom = "From"
				$scope.selectedTo = "To"

				Country.query (countries)->
					$scope.countries = countries.countries

				Company.query (companies) ->
					$scope.companies = companies.companies

				$scope.getStateByCountryId = (countryId) ->
					states = State.get {country_id: countryId}, ->
						$scope.states = states.states

				Nationality.query (nationalities) ->
					$scope.nationalities = nationalities.nationalities

				$scope.onCountry = (country) ->
					if(country?)
						$scope.country = country.name
						$scope.user.country_id = country.id
						$scope.getStateByCountryId(country.id)

				$scope.onState = (state) ->
					if(state?)
						$scope.state = state.name
						$scope.user.state_id = state.id

				$scope.onNationality = (nationality) ->
					if(nationality?)
						$scope.nationality = nationality.name
						$scope.employerNationality = new EmployerNationalities();
						$scope.employerNationality.name = nationality.name
						$scope.employerNationality.emloyer_id = $scope.user.uid;

				$scope.onCompany = (company) ->
					if company?
						$scope.companyName = company.name
						$scope.employerCompany.company_id = company.id
						$scope.companyIndustry = company.industry

				$scope.onCompanyCountry = (country) ->
					if(country?)
						$scope.companyCountry = country.name
						$scope.employerCompany.country_id = country.id
						$scope.getStateByCountryId(country.id)

				$scope.onCompanyState = (state) ->
					if(state?)
						$scope.companyState = state.name
						$scope.employerCompany.state_id = state.id

				####### Skills ######
				Skill.query (skills)->
					$scope.skillsTags = skills.skills

				Interest.query (interests) ->
					$scope.interestsTags = interests.interests

				sessionService.requestCurrentUser().then(
					(user) ->
						$state.go 'home.page' if !user?
						$scope.user = Utils.employerFromObject(user.employer)
						$scope.employerCompany.employer_id = $scope.user.uid
						$scope.skills.employer_id = $scope.user.uid
						$scope.interests.employer_id = $scope.user.uid
				,
					(error) ->
						console.log error
						$state.go 'home.page'
				)

				$scope.validatePersonal = (valid) ->
					$scope.pSubmitted = true
					$state.go 'main.signup_employer.company' if valid

				$scope.validateCompany = (valid) ->
					$scope.cSubmitted = true
					$state.go 'main.signup_employer.looking' if valid

				$scope.validateAndCreate = validateAndCreate

			validateAndCreate = (valid) ->
				createUser() if valid

			createUser = () ->
				$httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()
				createCompany().then(
					(company) ->
						$q.all([saveEmployerNationality(), saveCompany(company.company.id), saveSkills(), saveInterests(), saveUser()])
						.then(
							(data) ->
								console.log(data)
								$state.go 'main.employer_profile'
						,
							(error) ->
								console.log error
						)
					,
					(error) ->
						console.log error
				)

			createCompany = ->
				deferred = $q.defer()
				if $scope.companyIndustry == company.industry and $scope.employerCompany.company_id?
					deferred.resolve({company: {id: $scope.employerCompany.company_id}})
				else
					company = new Company()
					company.name = $scope.companyName
					company.industry = $scope.companyIndustry
					company.$save(
						(company) ->
							deferred.resolve(company.company.id)
					,
						(error) ->
							deferred.reject(error)
					)
				deferred.promise

			saveCompany = ->
				$scope.employerCompany.$save()

			saveEmployerNationality = ->
				$scope.employerNationality.$save()

			saveSkills = ->
				$scope.skills.skills = [{name: skill.name} for skill in $scope.selectedSkills]
				$scope.skills.$update()

			saveInterests = ->
				$scope.interests.interests = [{name: interest.name} for interest in $scope.selectedInterests]
				$scope.interests.$update()

			saveUser = ->
				$scope.user.$update()

			init()
	])