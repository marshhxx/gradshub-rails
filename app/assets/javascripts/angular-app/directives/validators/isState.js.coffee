IsState = (State) ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->

		State.query (states) ->
			scope.states = states.states
			ctrl.$validators.state = (value) ->
				return value in scope.states || value == ""

	}
angular
	.module('mepedia.directives')
	.directive('isState', IsState)
