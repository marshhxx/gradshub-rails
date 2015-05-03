IsMajor = (Major) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		Major.query (majors) ->
			scope.majors = majors.majors
			ctrl.$validators.major = (value) ->
				majorNames = scope.majors.map((major) -> major.name)
				return value? and (value.name in majorNames or value == "")

	}
angular
	.module('mepedia.directives')
	.directive('isMajor', IsMajor)