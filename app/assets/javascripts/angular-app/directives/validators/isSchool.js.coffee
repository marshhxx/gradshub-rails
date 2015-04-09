IsSchool = (School) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		School.query (schools) ->
			scope.schools = schools.schools
			ctrl.$validators.school = (value) ->
				return value in scope.schools || value == ""

	}
angular
	.module('mepedia.directives')
	.directive('isSchool', IsSchool)
