IsDegree = (Degree) ->
  {
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elm, attrs, ctrl) ->
    degreeNames = []

    Degree.query (degrees) ->
      degreeNames = degrees.degrees.map((degree) -> degree.name)
      initValidator()

    initValidator = ->
      ctrl.$validators.degree = (value) ->
        return value? and (value in degreeNames or value == "")

  }
angular
.module('mepedia.directives')
.directive('isDegree', IsDegree)