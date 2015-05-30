NationalitiesSelector = (Nationality) ->
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
		'<input name="nationality" type="text" ng-model="data" ' + required +
		' typeahead="nationality as nationality.name for nationality in nationalities | filter:$viewValue | limitTo:6" ' +
		'required class="form-control input-sm" id="nationality" typeahead-on-select="onSelect($item)" placeholder="' + placeholder + '" is-nationality>'
	link: (scope, elm, attrs, ctrl) ->

		Nationality.query (nationalities) ->
			scope.nationalities = nationalities.nationalities

	}
angular
	.module('mepedia.directives')
	.directive('nationalitySelector', NationalitiesSelector)