IsCountry = (Country) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		Country.query (countries) ->
			scope.countries = countries.countries
			ctrl.$validators.country = (value) ->
				return !value?|| value == "" || value in scope.countries

	}
angular
	.module('mepedia.directives')
	.directive('isCountry', IsCountry)