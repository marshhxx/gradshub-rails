StateSelector = (State) ->
	{
	restrict: 'E',
	require: 'ngModel',
	scope: {
		onSelect: '=',
		countryId: '='
	},
	template: (elem, attr) ->
		required = if attr.required == "" then "required" else ""
		placeholder = if attr.placeholder then attr.placeholder else ""
		'<input name="state" type="text" ng-model="state" typeahead="state as state.name for state in states | filter:$viewValue | limitTo:6" ' +
		 required + ' class="form-control" id="state" typeahead-on-select="onSelect($item)" placeholder="' + placeholder + '" is-state>'
	link: (scope, elm, attrs, ctrl) ->

		scope.$watch(
			-> scope.countryId
			,
			(id) ->
				State.query {country_id: id}, (countries) ->
					scope.states = countries.states
		)

	}
angular
	.module('mepedia.directives')
	.directive('stateSelector', StateSelector)