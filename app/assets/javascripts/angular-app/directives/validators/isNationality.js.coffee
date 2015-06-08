IsNationality = (Nationality) ->
  {
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elm, attrs, ctrl) ->
    nationalityNames = []

    Nationality.query (nationalities) ->
      nationalityNames = nationalities.nationalities.map (nationality) -> nationality.name
      initValidator()

    initValidator = () ->
      ctrl.$validators.nationality = (value) ->
        return value? and (value == "" or value in nationalityNames)

  }
angular
.module('mepedia.directives')
.directive('isNationality', IsNationality)