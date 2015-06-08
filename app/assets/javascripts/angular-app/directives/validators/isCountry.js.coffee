IsCountry = (Country) ->
  {
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elm, attrs, ctrl) ->
    countryNames = []

    Country.query (countries) ->
      countryNames = countries.countries.map((country) -> country.name)
      initValidator()

    initValidator = ->
      ctrl.$validators.country = (value) ->
        return !value? || value == "" || value in countryNames

  }
angular
.module('mepedia.directives')
.directive('isCountry', IsCountry)