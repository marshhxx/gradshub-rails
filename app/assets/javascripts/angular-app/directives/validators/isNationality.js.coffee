IsNationality = (Nationality) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		Nationality.query (nationalities) ->
			scope.nationalities = nationalities.nationalities
			ctrl.$validators.nationality = (value) ->
				return value in scope.nationalities || value == ""

	}
angular
.module('mepedia.directives')
.directive('isNationality', IsNationality)