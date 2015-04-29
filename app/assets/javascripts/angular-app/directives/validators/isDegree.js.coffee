IsDegree = (Degree) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		Degree.query (degrees) ->
			scope.degrees = degrees.degrees
			ctrl.$validators.degree = (value) ->
				degreeNames = scope.degrees.map((degree) -> degree.name)
				if (value?)
					return value.name in degreeNames || value == ""

	}
angular
	.module('mepedia.directives')
	.directive('isDegree', IsDegree)