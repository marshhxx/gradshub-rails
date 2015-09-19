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
    '<select id="country" ng-model="data" ng-change="onSelect()" name="country" class="form-control input-sm" ng-disabled="disabled" ' + required + '>' +
      '<option disabled value="" >Select Country</option>' +
      '<option value="{{country}}" ng-repeat="country in countries">{{country}}</option>' +
    '</select>'
  link: (scope, elm, attrs, ctrl) ->
    countryNameMap = {}

    scope.onSelect = () ->
      scope.onSelectCallback(countryNameMap[scope.data])

    Country.query (countries) ->
      scope.countries = countries.countries.map((country) -> country.name)
      for country in countries.countries
        countryNameMap[country.name] = country


  }
angular
.module('gradshub-ng.directives')
.directive('countrySelector', CountrySelector)