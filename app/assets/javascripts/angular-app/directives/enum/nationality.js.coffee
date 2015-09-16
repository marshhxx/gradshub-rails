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
    '<select id="nationality" ng-model="data" ng-change="onSelect()" name="country" class="form-control input-sm" ng-disabled="disabled" ' + required + '>' +
      '<option disabled value="" >Select Nationality</option>' +
      '<option value="{{nationality}}" ng-repeat="nationality in nationalities track by $index">{{nationality}}</option>' +
    '</select>'
  link: (scope, elm, attrs, ctrl) ->
    nationalityNameMap = {}

    scope.onSelect = () ->
      scope.onSelectCallback(nationalityNameMap[scope.data])

    Nationality.query (nationalities) ->
      scope.nationalities = nationalities.nationalities.map (nationality) -> nationality.name
      for nationality in nationalities.nationalities
        nationalityNameMap[nationality.name] = nationality

  }
angular
.module('gradshub-ng.directives')
.directive('nationalitySelector', NationalitiesSelector)