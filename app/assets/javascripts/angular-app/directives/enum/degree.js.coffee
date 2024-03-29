DegreeSelector = (Degree) ->
  {
  restrict: 'E',
  require: 'ngModel',
  scope: {
    onSelectCallback: '=onSelect'
    data: '=ngModel'
  },
  template: (elem, attr) ->
    required = if attr.required == "" then "required" else ""
    placeholder = if attr.placeholder then attr.placeholder else ""
    '<input name="degree" type="text" ng-model="data" ' + required + ' class="form-control input-sm" id="degree" ' +
      'placeholder="' + placeholder + '" ng-blur="onSelect(data)" typeahead-on-select="onSelect($item)" ' +
      'typeahead="degree for degree in degrees | filter:$viewValue | limitTo:6" class="form-control" >'
  link: (scope, elm, attrs, ctrl) ->
    degreeNameMap = {}

    scope.onSelect = (degree) ->
      value = degree
      if degree of degreeNameMap
        value = degreeNameMap[degree]
      scope.onSelectCallback(value)

    Degree.query (degrees) ->
      scope.degrees = degrees.degrees.map (degree) -> degree.name
      for degree in degrees.degrees
        degreeNameMap[degree.name] = degree

  }
angular
.module('gradshub-ng.directives')
.directive('degreeSelector', DegreeSelector)