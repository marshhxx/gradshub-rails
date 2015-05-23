isDate = () ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->
		ctrl.$validators.date = (value) ->
			if value?
				timestamp = Date.parse(value)
				return !isNaN(timestamp)
	}

angular
	.module('mepedia.directives')
	.directive('isDate', isDate)