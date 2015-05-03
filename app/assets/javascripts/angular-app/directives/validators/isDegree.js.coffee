IsDegree = (Degree) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		Degree.query (degrees) ->
			scope.degrees = degrees.degrees
			ctrl.$validators.degree = (value) ->
				degreeNames = scope.degrees.map((degree) -> degree.name)
				return value? and (value.name in degreeNames or value == "")

	}
angular
	.module('mepedia.directives')
	.directive('isDegree', IsDegree)