IsSchool = (School) ->
  {
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elm, attrs, ctrl) ->
    schoolNames = []

    School.query (schools) ->
      schoolNames = schools.schools.map((school) -> school.name)
      initValidator()

    initValidator = ->
      ctrl.$validators.school = (value) ->
        return value? and (value in schoolNames or value == "")

  }
angular
.module('gradshub-ng.directives')
.directive('isSchool', IsSchool)
