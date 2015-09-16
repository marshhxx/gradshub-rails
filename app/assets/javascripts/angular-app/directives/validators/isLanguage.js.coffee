IsLanguage = (Language) ->
  {
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elm, attrs, ctrl) ->
    languageNames = []

    Language.query (languages) ->
      languageNames = languages.languages.map((language) -> language.name)
      initValidator()

    initValidator = ->
      ctrl.$validators.language = (value) ->
        return !value? || value == "" || value in languageNames

  }
angular
.module('gradshub-ng.directives')
.directive('isLanguage', IsLanguage)