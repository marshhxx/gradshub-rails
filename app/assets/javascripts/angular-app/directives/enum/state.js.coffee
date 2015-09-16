StateSelector = (State) ->
  {
  restrict: 'E',
  require: 'ngModel',
  scope: {
    onSelectCallback: '=onSelect',
    countryId: '='
    data: '=ngModel'
  },
  template: (elem, attr) ->
    required = if attr.required == "" then "required" else ""
    '<select id="state" ng-model="data" ng-change="onSelect()" name="state" class="form-control input-sm" ng-disabled="isDisabled" ' + required + '>' +
      '<option disabled value="" >Select State</option>' +
      '<option value="{{state}}" ng-repeat="state in states">{{state}}</option>' +
    '</select>'
  link: (scope, elm, attrs, ctrl) ->
    scope.isDisabled = true
    stateNameMap = {}
    currentId = null

    scope.$watch(
      -> scope.countryId
    ,
      (id) ->
        if id?
          scope.isDisabled = false
          initStates(id)
        else
          states = []
          scope.isDisabled = true
    )

    scope.onSelect = () ->
      scope.onSelectCallback(stateNameMap[scope.data])

    initStates = (id) ->
      currentId = id
      State.query {country_id: id}, (states) ->
        scope.states = states.states.map (state) -> state.name
        for state in states.states
          stateNameMap[state.name] = state
  }
angular
.module('gradshub-ng.directives')
.directive('stateSelector', StateSelector)