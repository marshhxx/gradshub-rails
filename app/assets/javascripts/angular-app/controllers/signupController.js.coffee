angular.module('mepedia.controllers').controller("signupController", [
	'$scope', '$log', 'Country', 'State', 'Nationality', 'sessionService'
	($scope, $log, Country, State, Nationality, sessionService)->

		#$scope.user = sessionService.requestCurrentUser()

		$scope.months = [
			"Enero"
			"Febrero"
			"Marzo"
			"Abril"
			"Mayo"
			"Junio"
			"Julio"
			"Agosto"
			"Setiembre"
			"Octubre"
			"Noviembre"
			"Diciembre"
		]

		console.log($scope.user)
		$scope.myItem = {}

		$scope.type = true
		$scope.now = new Date
		$scope.currentYear = $scope.now.getFullYear()
		$scope.days = (num for num in [1..31])
		$scope.years = (num for num in [$scope.currentYear..1950])

		$scope.bio = undefined
		$scope.selectedMonth = "Month"
		$scope.selectedDay = "Day"
		$scope.selectedYear = "Year"
		$scope.country = undefined
		$scope.state = undefined
		$scope.nationality = undefined

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


])