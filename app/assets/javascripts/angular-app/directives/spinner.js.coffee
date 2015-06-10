Spinner = () ->
  {
  restrict: 'E',
  scope:{
    showSpinner: '=',
    size: '='
  },
  templateUrl: 'angular-app/templates/directives/spinner.html',
  link: ($scope, $element) ->

  }

angular
.module('mepedia.directives')
.directive('spinner', Spinner);