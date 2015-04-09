IsDegree = (Degree) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		Degree.query (degrees) ->
			scope.degrees = degrees.degrees
			ctrl.$validators.degree = (value) ->
				return value in scope.degrees || value == ""

	}
angular
	.module('mepedia.directives')
	.directive('isDegree', IsDegree)