SchoolSelector = (School) ->
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
		'<input name="school" type="text" ng-model="data" ' + required + ' class="form-control" id="school" placeholder="' + placeholder + '"' +
		' typeahead="school as school.name for school in schools | filter:$viewValue | limitTo:6" class="form-control" ' +
		' typeahead-on-select="onSelect($item)" is-school>'
	link: (scope, elm, attrs, ctrl) ->

		School.query (schools) ->
			scope.schools = schools.schools

	}
angular
	.module('mepedia.directives')
	.directive('schoolSelector', SchoolSelector)