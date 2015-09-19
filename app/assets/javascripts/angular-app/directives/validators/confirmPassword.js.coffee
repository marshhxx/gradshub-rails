Confirm = ->
  {
    scope: {
      reference: '=toConfirm',
    },
    restrict: 'A',
    require: 'ngModel',
    link: (scope, element, attr, ctrl) ->
      ctrl.$validators.passwordConfirmed = (value) ->
        return value == scope.reference
  }
angular
.module('gradshub-ng.directives')
.directive('confirmPassword', Confirm)
