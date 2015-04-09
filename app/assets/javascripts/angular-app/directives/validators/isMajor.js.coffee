IsMajor = (Major) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		Major.query (majors) ->
			scope.majors = majors.majors
			ctrl.$validators.major = (value) ->
				return value in scope.majors || value == ""

	}
angular
	.module('mepedia.directives')
	.directive('isMajor', IsMajor)