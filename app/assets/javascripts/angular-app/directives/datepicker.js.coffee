DatePicker = (Utils) ->
  {
  restrict: 'E',
  scope: {
    noDay: '=?',
    noMonth: '=?',
    date: '=ngModel',
    disabled: '=?',
    future: '=?'
  },
  templateUrl: 'angular-app/templates/directives/datepicker.html',
  link: ($scope, $element) ->
    $scope.noDay = $scope.noDay || false;
    $scope.noMonth = $scope.noMonth || false;
    $scope.days = (num for num in [1..31])
    startDate = new Date()
    if $scope.future
      startDate = new Date(startDate.getFullYear() + 30, 0, 0, 0, 0, 0, 0)
    $scope.years = (num for num in [startDate.getFullYear()..1950])
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

    $scope.refreshDate = () ->
      $scope.date = [$scope.dateYear, Utils.getMonthNumber($scope.dateMonth),
                     $scope.dateDay].join('-') if $scope.dateYear != "Year" and $scope.dateMonth != "Month" and $scope.dateDay != "Day"

    initDate($scope.date)
}
angular
  .module('gradshub-ng.directives')
  .directive('simpledatepicker', DatePicker);