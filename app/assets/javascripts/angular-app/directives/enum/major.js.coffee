MajorSelector = (Major) ->
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
    '<input name="major" type="text" ng-model="data" class="form-control input-sm" id="major" ' +
      'placeholder="' + placeholder + '" ng-blur="onSelect(data)" typeahead-on-select="onSelect($item)" ' +
      'typeahead="major for major in majors | filter:$viewValue | limitTo:6" ' + required + '>'
  link: (scope, elm, attrs, ctrl) ->
    majorNameMap = {}

    scope.onSelect = (major) ->
      value = major
      if major of majorNameMap
        value = majorNameMap[major]
      scope.onSelectCallback(value)

    Major.query (majors) ->
      scope.majors = majors.majors.map (major) -> major.name
      for major in majors.majors
        majorNameMap[major.name] = major

  }
angular
.module('mepedia.directives')
.directive('majorSelector', MajorSelector)