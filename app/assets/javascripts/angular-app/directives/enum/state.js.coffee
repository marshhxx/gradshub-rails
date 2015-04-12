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
		 required + ' class="form-control" ng-disabled="isDisabled" id="state" typeahead-on-select="onSelect($item)" placeholder="' + placeholder + '" is-state>'
	link: (scope, elm, attrs, ctrl) ->
		scope.isDisabled = true
		scope.$watch(
			-> scope.countryId
			,
			(id) ->
				if id?
					scope.isDisabled = false
					State.query {country_id: id}, (states) ->
						scope.states = states.states
		)

	}
angular
	.module('mepedia.directives')
	.directive('stateSelector', StateSelector)