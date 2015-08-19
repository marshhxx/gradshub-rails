Focus = () ->
  {
  scope: {
    trigger: '=focus',
  }
  link: (scope, element) ->
    scope.$watch 'trigger', (value) ->
      if value == true
        element[0].focus()
        scope.trigger = false
    return
  }
angular
.module('mepedia.directives')
.directive('focus', Focus);