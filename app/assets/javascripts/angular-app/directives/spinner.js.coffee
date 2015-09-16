Spinner = () ->
  {
  restrict: 'E',
  scope:{
    showSpinner: '=',
  },
  templateUrl: 'angular-app/templates/directives/spinner.html',
  link: ($scope, $element) ->

  }

angular
.module('gradshub-ng.directives')
.directive('spinner', Spinner);