IsState = (State) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		scope.$watch(
			-> scope.countryId
		,
			(id) ->
				if id?
					State.query {country_id: id}, (states) ->
						scope.states = states.states
						ctrl.$validators.state = (value) ->
							stateNames = scope.states.map((state) -> state.name)
							return scope.states? and (value.name in stateNames or value == "")
		)

	}
angular
	.module('mepedia.directives')
	.directive('isState', IsState)
