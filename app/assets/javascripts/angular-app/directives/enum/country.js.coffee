CountrySelector = (Country) ->
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
    '<input name="country" type="text" ng-model="data" ' + required +
      ' typeahead="country for country in countries | filter:$viewValue | limitTo:6"   ng-blur=onSelect(data) ' +
      'class="form-control input-sm" id="country" typeahead-on-select="onSelect($item)" placeholder="' + placeholder + '" is-country>'
  link: (scope, elm, attrs, ctrl) ->
    countryNameMap = {}

    scope.onSelect = (country) ->
      scope.onSelectCallback(countryNameMap[country])

    Country.query (countries) ->
      scope.countries = countries.countries.map((country) -> country.name)
      for country in countries.countries
        countryNameMap[country.name] = country


  }
angular
.module('mepedia.directives')
.directive('countrySelector', CountrySelector)