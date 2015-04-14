MajorSelector = (Major) ->
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
		'<input name="major" type="text" ng-model="data" class="form-control" id="major" placeholder="' + placeholder + '" ' +
		'typeahead="major as major.name for major in majors | filter:$viewValue | limitTo:6" ' + required + ' typeahead-on-select="onSelect($item)" is-major>'
	link: (scope, elm, attrs, ctrl) ->

		Major.query (majors) ->
			scope.majors = majors.majors

	}
angular
	.module('mepedia.directives')
	.directive('majorSelector', MajorSelector)