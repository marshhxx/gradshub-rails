SchoolSelector = (School) ->
  {
  restrict: 'E',
  require: 'ngModel',
  scope: {
    onSelectCallback: '=onSelect',
    data: '=ngModel'
  },
  template: (elem, attr) ->
    required = if attr.required == "" then "required" else ""
    placeholder = if attr.placeholder then attr.placeholder else ""
    '<input name="school" type="text" ng-model="data" ' + required + ' class="form-control input-sm" id="school" placeholder="' + placeholder + '"' +
      ' typeahead="school for school in schools | filter:$viewValue | limitTo:6" ng-blur="onSelect(data)" ' +
      ' typeahead-on-select="onSelect($item)" is-school>'
  link: (scope, elm, attrs, ctrl) ->
    schoolNameMap = {}

    scope.onSelect = (school) ->
      scope.onSelectCallback(schoolNameMap[school]) if school of schoolNameMap

    School.query (schools) ->
      scope.schools = schools.schools.map (school) -> school.name
      for school in schools.schools
        schoolNameMap[school.name] = school

  }
angular
.module('mepedia.directives')
.directive('schoolSelector', SchoolSelector)