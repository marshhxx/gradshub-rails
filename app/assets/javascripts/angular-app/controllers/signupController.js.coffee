angular.module('mepedia.controllers').controller("signupController", [
	'$scope', '$log', 'Country', 'State', 'Nationality', 'sessionService', 'School', 'Skills'
	($scope, $log, Country, State, Nationality, sessionService, School, Skills)->

		$scope.user = sessionService.requestCurrentUser()

		$scope.tempUser = {}

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

		console.log($scope.user)
		$scope.myItem = {}

		$scope.type = true
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

		$scope.showType = ->
			$scope.type = not $scope.type

		countries = Country.get ->
			console.log(countries.countries)
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

		####### Interests ######
		skills = Skills.get ->
			$scope.skills = skills.skills

		$scope.createUser = () ->
				$scope.user = sessionService.requestCurrentUser()
				if($scope.user?)
					$scope.user.bio = $scope.tempUser.bio
					monthNumber = getMonthNumber($scope.selectedMonth)
					$scope.user.birth = $scope.selectedYear + "-" + monthNumber + "-" + $scope.selectedDay
					$scope.user.country_id = $scope.country.id
					$scope.user.state_id = $scope.state.id
					$scope.user.nationalities_ids =  []
					$scope.user.nationalities_ids.push $scope.nationality.id

					$scope.user.educations = []
					education = []
					education.school_id = $scope.school.id
					education.state_id = $scope.schoolState.id
					education.major_id = 1 #$scope.tempUser.major
					education.degree_id = 1 #$scope.tempUser.degree
					$scope.user.educations.push education

					$scope.user.skills = $scope.tempUser.skills.name

					console.log($scope.user)


])