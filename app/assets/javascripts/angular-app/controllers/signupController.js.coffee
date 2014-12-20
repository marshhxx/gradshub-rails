angular.module('mepedia.controllers').controller("signupController", [
	'$scope', '$log', 'Country'
	($scope, $log, Country)->

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



		$scope.now = new Date
		$scope.currentYear = $scope.now.getFullYear()

		$scope.days = (num for num in [1..31])

		$scope.years = (num for num in [$scope.currentYear..1950])

		$scope.selectedMonth = "Month"
		$scope.selectedDay = "Day"
		$scope.selectedYear = "Year"


		$scope.setMonth = (month) ->
			$scope.selectedMonth = month

		$scope.setDay = (day) ->
			$scope.selectedDay = day

		$scope.setYear = (year) ->
			$scope.selectedYear = year
			$log.log $scope.currentYear

		#$scope.formData = {}

		# function to process the form
		#$scope.processForm = ->
		#	alert "awesome!"


		$scope.type = true
		$scope.showType = ->
			$scope.type = not $scope.type

		$scope.selectedFrom = "From"
		$scope.selectedTo = "To"

		$scope.selected = undefined

		countries = Country.get ->
			console.log(countries.countries)
			$scope.countries = countries.countries

		$scope.items = [
			"The first choice!"
			"And another choice for you."
			"but wait! A third!"
		]
		$scope.status = isopen: false
		$scope.toggled = (open) ->
			$log.log "Dropdown is now: ", open
			return

		$scope.toggleDropdown = ($event) ->
			$event.preventDefault()
			$event.stopPropagation()
			$scope.status.isopen = not $scope.status.isopen
			return

])