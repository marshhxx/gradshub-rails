IsMajor = (Major) ->
  {
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elm, attrs, ctrl) ->
    majorNames = []

    Major.query (majors) ->
      majorNames = majors.majors.map((major) -> major.name)
      initValidator()

    initValidator = ->
      ctrl.$validators.major = (value) ->
        return value? and (value in majorNames or value == "")

  }
angular
.module('gradshub-ng.directives')
.directive('isMajor', IsMajor)