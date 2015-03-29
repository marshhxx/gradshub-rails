angular
	.module('mepedia.controllers')
	.controller("candidateSignupController",
	['$scope', '$q', '$http', '$state', '$log', 'Country', 'State', 'Nationality', 'sessionService', 'School', 'Skill', 'Candidate','Major', 'Degree','Interest', 'CandidateNationalities', 'Education', 'CandidateSkills',
	($scope, $q, $httpProvider, $state, $log, Country, State, Nationality, sessionService, School, Skill, Candidate, Major, Degree, Interest, CandidateNationalities, Education, CandidateSkills)->

		init = ->
			$scope.selectedTags = []
			$scope.months = [
				"January"
				"February"
				"March"
				"April"
				"May"
				"June"
				"July"
				"August"
				"September"
				"October"
				"November"
				"December"
			]

			$scope.myItem = {}

			$scope.looking = false
			$scope.eSubmitted = false
			$scope.pSubmitted = false
			$scope.great = true
			$scope.now = new Date
			$scope.currentYear = $scope.now.getFullYear()
			$scope.days = (num for num in [1..31])
			$scope.years = (num for num in [$scope.currentYear..1950])

			$scope.birthMonth = $scope.endDateMonth = $scope.startDateMonth = "Month"
			$scope.birthDay = "Day"
			$scope.birthYear = $scope.endDateYear = $scope.startDateYear = "Year"

			$scope.selectedFrom = "From"
			$scope.selectedTo = "To"

			$scope.setMonth = (month, placeholder) ->
				if placeholder == 'birth'
					$scope.birthMonth = month
				else if placeholder == 'start'
					$scope.startDateMonth = month
				else if placeholder == 'end'
					$scope.endDateMonth == month

			$scope.setDay = (day) ->
				$scope.birthDay = day

			$scope.setYear = (year, placeholder) ->
				if placeholder == 'birth'
					$scope.birthYear = year
				else if placeholder == 'start'
					$scope.startDateYear = year
				else if placeholder == 'end'
					$scope.endDateYear == year

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
				$scope.country = country
				if($scope.country?)
					$scope.getStateByCountryId($scope.country.id)

			$scope.onState = (state) ->
				if(state?)
					$scope.state = state

			$scope.onNationality = (nationality) ->
				if(nationality?)
					$scope.nationality = nationality

			####### Eduaction ######

			schools = School.get ->
				$scope.schools = schools.schools

			$scope.onSchool = (school) ->
				if(school?)
					$scope.school = school

			$scope.onSchoolCountry = (country) ->
				$scope.schoolCountry = country
				if($scope.schoolCountry?)
						$scope.getStateByCountryId($scope.schoolCountry.id)

			$scope.onSchoolState = (state) ->
				if(state?)
					$scope.schoolState = state

			majors = Major.get ->
				$scope.majors = majors.majors

			$scope.onMajor = (major) ->
				if(major?)
					$scope.major = major

			degrees = Degree.get ->
				$scope.degrees = degrees.degrees

			$scope.onDegree= (degree) ->
				if(degree?)
					$scope.degree = degree

			####### Skills ######
			skills = Skill.get ->
				$scope.skillsTags = skills.skills

			$scope.selectedSkills = [];

			sessionService.requestCurrentUser().then(
				(user) ->
					$state.go 'home.page' if !user?
					$scope.user = user.candidate
					$scope.validateAndCreate = validateAndCreate
				,
				(error) ->
					console.log error
					$state.go 'home.page'
			)

			$scope.validatePersonal = (valid) ->
				$scope.pSubmitted = true
				customCondition = dateSet($scope.birthDay) and $scope.birthMonth in $scope.months  and dateSet($scope.birthYear)
				$state.go 'main.signup.education' if valid and customCondition

			$scope.validateEducation = (valid) ->
				$scope.eSubmitted = true
				$state.go 'main.signup.interests' if valid

		init()

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

		getMonthNumber = (month) ->
			if month is "January"
				"1"
			else if month is "February"
				"2"
			else if month is "March"
				"3"
			else if month is "April"
				"4"
			else if month is "May"
				"5"
			else if month is "June"
				"6"
			else if month is "July"
				"7"
			else if month is "August"
				"8"
			else if month is "September"
				"9"
			else if month is "October"
				"10"
			else if month is "November"
				"11"
			else if month is "December"
				"12"

		dateSet = (date) ->
			!isNaN(parseFloat(date))

		saveCandidateNationality = ->
			candidateNationality = new CandidateNationalities()
			candidateNationality.name = $scope.nationality.name
			candidateNationality.candidate_id = $scope.user.uid
			candidateNationality.$save()

		saveEducation = ->
			education = new Education()
			education.school_id = $scope.school.id
			education.country_id = $scope.schoolCountry.id
			education.state_id = $scope.schoolState.id
			education.major_id = $scope.major.id
			education.degree_id = $scope.degree.id
			education.description = $scope.educationDescription
			education.start_date = [$scope.startDateYear, getMonthNumber($scope.startDateMonth), '01'].join('-')
			education.end_date = [$scope.endDateYear, getMonthNumber($scope.endDateMonth), '01'].join('-')
			education.candidate_id = $scope.user.uid
			education.$save()

		saveSkills = ->
			skills = new CandidateSkills()
			skills.candidate_id = $scope.user.uid
			skills.skills = [{name: skill.name} for skill in $scope.selectedSkills]
			skills.$update()

		saveUser = ->
			user = new Candidate()
			user.name = $scope.user.name
			user.lastname = $scope.user.lastname
			user.email = $scope.user.email
			user.uid = $scope.user.uid
			user.tag = $scope.user.tag
			user.birth = [$scope.birthYear, getMonthNumber($scope.birthMonth), $scope.birthDay].join('-')
			user.country_id = $scope.country.id
			user.state_id = $scope.state.id
			user.$update()
])