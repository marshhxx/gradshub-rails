IsMajor = (Major) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		Major.query (majors) ->
			scope.majors = majors.majors
			ctrl.$validators.major = (value) ->
				majorNames = scope.majors.map((major) -> major.name)
				if (value?)
					return value.name in majorNames || value == ""

	}
angular
	.module('mepedia.directives')
	.directive('isMajor', IsMajor)