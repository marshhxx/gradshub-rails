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
    placeholder = if attr.placeholder then attr.placeholder else ""
    '<input name="state" type="text" ng-model="data" typeahead="state for state in states | filter:$viewValue | limitTo:6" ng-blur="onSelect(data)" ' +
      required + ' class="form-control input-sm" ng-disabled="isDisabled" id="state" typeahead-on-select="onSelect($item)" placeholder="' + placeholder + '" is-state>'
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

    scope.onSelect = (state) ->
      scope.onSelectCallback(stateNameMap[state])

    initStates = (id) ->
      currentId = id
      State.query {country_id: id}, (states) ->
        scope.states = states.states.map (state) -> state.name
        for state in states.states
          stateNameMap[state.name] = state
  }
angular
.module('mepedia.directives')
.directive('stateSelector', StateSelector)