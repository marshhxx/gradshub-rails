angular
	.module('mepedia.controllers')
	.controller("candidateSignupController",
	['$scope', '$q', '$http', '$state', '$log', 'Country', 'State', 'Nationality', 'sessionService', 'School', 'Skill', 'Candidate','Major', 'Degree','Interest', 'CandidateNationalities', 'Education', 'CandidateSkills', 'Utils'
	($scope, $q, $httpProvider, $state, $log, Country, State, Nationality, sessionService, School, Skill, Candidate, Major, Degree, Interest, CandidateNationalities, Education, CandidateSkills, Utils)->

		init = ->
			$scope.selectedTags = []
			$scope.eSubmitted = false
			$scope.pSubmitted = false
			$scope.education = new Education()
			$scope.skills = new CandidateSkills()

			$scope.selectedFrom = "From"
			$scope.selectedTo = "To"

			Country.query (countries) ->
				$scope.countries = countries.countries

			$scope.getStateByCountryId = (countryId) ->
				states = State.query {country_id: countryId}, ->
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
					$scope.candidateNationality = new CandidateNationalities();
					$scope.candidateNationality.name = nationality.name
					$scope.candidateNationality.candidate_id = $scope.user.uid;

			####### Eduaction ######

			School.query (schools) ->
				$scope.schools = schools.schools

			$scope.onSchool = (school) ->
				if(school?)
					$scope.school = school.name
					$scope.education.school_id = school.id

			$scope.onSchoolCountry = (country) ->
				if(country?)
					$scope.schoolCountry = country.name
					$scope.education.country_id = country.id
					$scope.getStateByCountryId(country.id)

			$scope.onSchoolState = (state) ->
				if(state?)
					$scope.schoolState = state.name
					$scope.education.state_id = state.id

			Major.query (majors) ->
				$scope.majors = majors.majors

			$scope.onMajor = (major) ->
				if(major?)
					$scope.major = major.name
					$scope.education.major_id = major.id

			Degree.query (degrees) ->
				$scope.degrees = degrees.degrees

			$scope.onDegree = (degree) ->
				if(degree?)
					$scope.degree = degree.name
					$scope.education.degree_id = degree.id

			####### Skills ######
			Skill.query (skills) ->
				$scope.skillsTags = skills.skills

			$scope.selectedSkills = [];

			sessionService.requestCurrentUser().then(
				(user) ->
					$state.go 'home.page' if !user?
					$scope.user = Utils.candidateFromObject(user.candidate)
					$scope.education.candidate_id = $scope.user.uid
					$scope.skills.candidate_id = $scope.user.uid
				,
				(error) ->
					console.log error
					$state.go 'home.page'
			)

			$scope.validatePersonal = (valid) ->
				$scope.pSubmitted = true
				$scope.country.$error = $scope.country.name in $scope.countries
				$state.go 'main.signup_candidate.education' if valid

			$scope.validateEducation = (valid) ->
				$scope.eSubmitted = true
				$state.go 'main.signup_candidate.interests' if valid

			$scope.validateAndCreate = validateAndCreate

		validateAndCreate = (valid) ->
			createUser() if valid

		createUser = () ->
			$httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()
			$q.all([saveCandidateNationality(), saveEducation(), saveSkills(), saveUser()])
				.then(
					(data) ->
						console.log(data)
						$state.go 'main.candidate_profile'
					,
					(error) ->
						console.log error
				)

		saveEducation = ->
			$scope.education.$save()

		saveCandidateNationality = ->
			$scope.candidateNationality.$save()

		saveSkills = ->
			$scope.skills.skills = [{name: skill.name} for skill in $scope.selectedSkills]
			$scope.skills.$update()

		saveUser = ->
			$scope.user.$update()

		init()
])