IsState = (State) ->
  {
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elm, attrs, ctrl) ->
    stateNames = []

    scope.$watch(
      -> scope.countryId
    ,
      (id) ->
        if id?
          State.query {country_id: id}, (states) ->
            stateNames = states.states.map((state) -> state.name)
            initValidator()
    )

    initValidator = ->
      ctrl.$validators.state = (value) ->
        return stateNames? and (value in stateNames or value == "" or !value?)

  }
angular
.module('gradshub-ng.directives')
.directive('isState', IsState)
