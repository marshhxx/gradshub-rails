IsSchool = (School) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		School.query (schools) ->
			scope.schools = schools.schools
			ctrl.$validators.school = (value) ->
				schoolNames = scope.schools.map((school) -> school.name)
				if (value?)
					return value.name in schoolNames || value == ""

	}
angular
	.module('mepedia.directives')
	.directive('isSchool', IsSchool)
