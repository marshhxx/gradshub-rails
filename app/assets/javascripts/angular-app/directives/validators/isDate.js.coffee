isDate = () ->
	{
	restrict: 'A',
	require: 'ngModel',
	link: (scope, elm, attrs, ctrl) ->
		ctrl.$validators.date = (value) ->
			if value?
				timestamp = new Date(value.replace(/-/g, "/"))
				return !isNaN(timestamp)
	}

angular
	.module('mepedia.directives')
	.directive('isDate', isDate)