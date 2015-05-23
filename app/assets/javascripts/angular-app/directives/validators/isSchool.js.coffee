IsSchool = (School) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		School.query (schools) ->
			scope.schools = schools.schools
			ctrl.$validators.school = (value) ->
				schoolNames = scope.schools.map((school) -> school.name)
				return value? and (value.name in schoolNames or value == "")

	}
angular
	.module('mepedia.directives')
	.directive('isSchool', IsSchool)
