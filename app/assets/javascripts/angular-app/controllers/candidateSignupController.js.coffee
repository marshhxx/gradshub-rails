angular
	.module('mepedia.controllers')
	.controller("candidateSignupController",
	['$scope', '$q', '$http', '$state', '$log', 'Country', 'State', 'Nationality', 'sessionService', 'School', 'Skill', 'Candidate','Major', 'Degree','Interest', 'CandidateNationalities', 'Education', 'CandidateSkills', 'Utils'
	($scope, $q, $httpProvider, $state, $log, Country, State, Nationality, sessionService, School, Skill, Candidate, Major, Degree, Interest, CandidateNationalities, Education, CandidateSkills, Utils)->

		init = ->
			$scope.selectedTags = []
			$scope.looking = false
			$scope.eSubmitted = false
			$scope.pSubmitted = false
			$scope.great = true
			$scope.education = new Education()
			$scope.skills = new CandidateSkills()

			$scope.selectedFrom = "From"
			$scope.selectedTo = "To"

			$scope.showLookingMindsSignup = () ->
				if(!$scope.looking)
					$scope.looking = true
					$scope.great = false

			$scope.showGreatMindsSignup = () ->
				if(!$scope.great)
					$scope.great = true
					$scope.looking = false

			countries = Country.get ->
				$scope.countries = countries.countries

			$scope.getStateByCountryId = (countryId) ->
				states = State.get {country_id: countryId}, ->
					$scope.states = states.states

			nationalities = Nationality.get ->
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
					$scope.candidateNationality = new CandidateNationalities();
					$scope.candidateNationality.candidate_id = $scope.user.uid;

			####### Eduaction ######

			schools = School.get ->
				$scope.schools = schools.schools

			$scope.onSchool = (school) ->
				if(school?)
					$scope.education.school_id = school.id

			$scope.onSchoolCountry = (country) ->
				if(country?)
					$scope.education.country_id = country.id
					$scope.getStateByCountryId(country.id)

			$scope.onSchoolState = (state) ->
				if(state?)
					$scope.education.state_id = state.id

			majors = Major.get ->
				$scope.majors = majors.majors

			$scope.onMajor = (major) ->
				if(major?)
					$scope.education.major_id = major.id

			degrees = Degree.get ->
				$scope.degrees = degrees.degrees

			$scope.onDegree= (degree) ->
				if(degree?)
					$scope.education.degree_id = degree.id

			####### Skills ######
			skills = Skill.get ->
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
				$state.go 'main.signup.education' if valid

			$scope.validateEducation = (valid) ->
				$scope.eSubmitted = true
				$state.go 'main.signup.interests' if valid

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