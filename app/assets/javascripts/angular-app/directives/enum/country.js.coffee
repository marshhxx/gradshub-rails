CountrySelector = (Country) ->
	{
		restrict: 'E',
		require: 'ngModel',
		scope: {
			onSelect: '=',
			data: '=ngModel'
		},
		template: (elem, attr) ->
			required = if attr.required == "" then "required" else ""
			placeholder = if attr.placeholder then attr.placeholder else ""
			'<input name="country" type="text" ng-model="data" ' + required +
			' typeahead="country as country.name for country in countries | filter:$viewValue | limitTo:6" ' +
			'class="form-control" id="country" typeahead-on-select="onSelect($item)" placeholder="' + placeholder + '" is-country>'
		link: (scope, elm, attrs, ctrl) ->

			Country.query (countries) ->
				scope.countries = countries.countries

	}
angular
	.module('mepedia.directives')
	.directive('countrySelector', CountrySelector)