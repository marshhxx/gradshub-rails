angular
	.module('mepedia.controllers')
	.controller("candidateSignupController",
	['$scope', '$http', '$state', '$log', 'Country', 'State', 'Nationality', 'sessionService', 'School', 'Skill', 'Candidate','Major', 'Degree','Interest'
	($scope, $httpProvider, $state, $log, Country, State, Nationality, sessionService, School, Skill, Candidate, Major, Degree, Interest)->

		init = ->
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

			$scope.myItem = {}

			$scope.looking = false
			$scope.great = true
			$scope.now = new Date
			$scope.currentYear = $scope.now.getFullYear()
			$scope.days = (num for num in [1..31])
			$scope.years = (num for num in [$scope.currentYear..1950])

			$scope.selectedMonth = "Month"
			$scope.selectedDay = "Day"
			$scope.selectedYear = "Year"

			$scope.selectedFrom = "From"
			$scope.selectedTo = "To"

			$scope.setMonth = (month) ->
				$scope.selectedMonth = month

			$scope.setDay = (day) ->
				$scope.selectedDay = day

			$scope.setYear = (year) ->
				$scope.selectedYear = year
				$log.log $scope.currentYear

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
					user = user.candidate
					$scope.createUser = createUser
				,
				(error) ->
					console.log error
					$state.go 'home.page'
			)

		init()
		createUser = () ->

		#console.log($scope.newTags);
		#	user.bio = $scope.tempUser.bio
		#	monthNumber = getMonthNumber($scope.selectedMonth)
		#	user.birth = $scope.selectedYear + "-" + monthNumber + "-" + $scope.selectedDay
		#	console.log $scope.country
			user.country_id = $scope.country.id
			user.state_id = $scope.state.id
		#	user.nationalities_ids =  []
		#	user.nationalities_ids.push $scope.nationality.id

		#	user.educations = []
		#	education = []
		#	education.school_id = $scope.school.id
		#	education.state_id = $scope.schoolState.id
		#	education.major_id = $scope.major.id
		#	education.degree_id = $scope.degree.id
		#	user.educations.push education

		#	user.skills = $scope.tempUser.skills.name
			$httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()
			user.$update () ->
				console.log(user)
])