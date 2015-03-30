DatePicker = () ->
	{
	restrict: 'E',
	scope: {
		noDay: '=?',
		noMonth: '=?',
		date: '='
	},
	templateUrl: 'angular-app/templates/directives/datepicker.html',
	link: ($scope, $element) ->
		$scope.noDay = $scope.noDay || false;
		$scope.noMonth = $scope.noMonth || false;
		$scope.days = (num for num in [1..31])
		$scope.years = (num for num in [new Date().getFullYear()..1950])
		$scope.months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October",
		                 "November", "December"]

		$scope.dateDay = '01' if $scope.noDay
		$scope.monthDay = '01' if $scope.noMonth

		if $scope.date != '' and $scope.date
			split = $scope.date.split('-')
			$scope.dateYear = split[0]
			$scope.dateMonth = split[1]
			$scope.dateDay = split[2]
		else
			$scope.dateYear = "Year"
			$scope.dateMonth = "Month"
			$scope.dateDay = "Day"

		$scope.setDay = (day) ->
			$scope.dateDay = day
			refreshDate()

		$scope.setMonth = (month) ->
			$scope.dateMonth = month
			refreshDate()

		$scope.setYear = (year) ->
			$scope.dateYear = year
			refreshDate()

		refreshDate = () ->
			$scope.date = [$scope.dateYear, getMonthNumber($scope.dateMonth), $scope.dateDay].join('-') if $scope.dateYear != "Year" and $scope.dateMonth != "Month" and $scope.dateDay != "Day"

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
	}
angular
	.module('mepedia.directives')
	.directive('simpledatepicker', DatePicker);