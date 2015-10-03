StateWrapper = ($rootScope) ->

  stateWrapper = {}

  $rootScope.$on '$stateChangeSuccess', (ev, to, toParams, from, fromParams) ->
    stateWrapper.previousState = from.name;
    stateWrapper.currentState = to.name;

  return stateWrapper

angular
.module('gradshub-ng.services')
.factory('stateWrapper', StateWrapper)