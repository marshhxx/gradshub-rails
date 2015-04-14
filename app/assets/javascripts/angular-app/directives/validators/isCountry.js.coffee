IsCountry = (Country) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		Country.query (countries) ->
			scope.countries = countries.countries
			ctrl.$validators.country = (value) ->
				countryNames = scope.countries.map((country) -> country.name)
				return !value?|| value == "" || value.name in countryNames

	}
angular
	.module('mepedia.directives')
	.directive('isCountry', IsCountry)