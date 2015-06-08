NationalitiesSelector = (Nationality) ->
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
    '<input name="nationality" type="text" ng-model="data" ' + required +
      ' typeahead="nationality for nationality in nationalities | filter:$viewValue | limitTo:6" ng-blur="onSelect(data)" ' +
      'required class="form-control input-sm" id="nationality" typeahead-on-select="onSelect($item)" placeholder="' + placeholder + '" is-nationality>'
  link: (scope, elm, attrs, ctrl) ->
    nationalityNameMap = {}

    scope.onSelect = (nationality) ->
      scope.onSelectCallback(nationalityNameMap[nationality]) if nationality of nationalityNameMap

    Nationality.query (nationalities) ->
      scope.nationalities = nationalities.nationalities.map (nationality) -> nationality.name
      for nationality in nationalities.nationalities
        nationalityNameMap[nationality.name] = nationality

  }
angular
.module('mepedia.directives')
.directive('nationalitySelector', NationalitiesSelector)