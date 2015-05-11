DatePicker = (Utils) ->
	{
	restrict: 'E',
	scope: {
		noDay: '=?',
		noMonth: '=?',
		date: '=ngModel',
		disabled: '=?',
		isStart: '=?',
		isEnd:'=?'
	},
	templateUrl: 'angular-app/templates/directives/datepicker.html',
	link: ($scope, $element) ->
		$scope.noDay = $scope.noDay || false;
		$scope.noMonth = $scope.noMonth || false;
		$scope.days = (num for num in [1..31])
		$scope.years = (num for num in [new Date().getFullYear()..1950])
		$scope.months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October",
		                 "November", "December"]

		$scope.$watch('date',
			(value) ->
				initDate(value)
		)


		initDate = (date) ->
			if date != '' and date
				split = date.split('-')
				$scope.dateYear = split[0]
				$scope.dateMonth = Utils.getMonthByNumber(split[1])
				$scope.dateDay = split[2]
			else
				$scope.dateYear = "Year"
				$scope.dateMonth = "Month"
				$scope.dateDay = "Day"
			$scope.dateDay = '01' if $scope.noDay
			$scope.dateMonth = 'January' if $scope.noMonth

		initDate($scope.date)

		$scope.setDay = (day) ->
			$scope.dateDay = day
			refreshDate()

		$scope.setMonth = (month) ->
			$scope.dateMonth = month
			refreshDate()
			checkCorrectDate()

		$scope.setYear = (year) ->
			$scope.dateYear = year
			refreshDate()
			checkCorrectDate()

		checkCorrectDate = () ->
			if $scope.dateYear != 'Year' and $scope.dateMonth != 'Month'
				if $scope.isStart
					$scope.$emit('dateSelected', 
					{
						'dateMonth': Utils.getMonthNumber($scope.dateMonth),
						'dateYear': $scope.dateYear,
						'isStart': true
					})
				else if $scope.isEnd
					$scope.$emit('dateSelected',
					{
						'dateMonth': Utils.getMonthNumber($scope.dateMonth),
						'dateYear': $scope.dateYear,
						'isEnd': true
					})

		refreshDate = () ->
			$scope.date = [$scope.dateYear, Utils.getMonthNumber($scope.dateMonth), $scope.dateDay].join('-') if $scope.dateYear != "Year" and $scope.dateMonth != "Month" and $scope.dateDay != "Day"
	}
angular
	.module('mepedia.directives')
	.directive('simpledatepicker', DatePicker);