IsNationality = (Nationality) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		Nationality.query (nationalities) ->
			scope.nationalities = nationalities.nationalities
			ctrl.$validators.nationality = (value) ->
				nationalityNames = scope.nationalities.map((nationality) -> nationality.name)
				return name in nationalityNames || value == ""

	}
angular
.module('mepedia.directives')
.directive('isNationality', IsNationality)