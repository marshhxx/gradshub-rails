Language = (Utils) ->
  {
  scope: {
    language: '=data',
    updateLanguage: '=',
    onDelete: '='
  },
  templateUrl: 'angular-app/templates/directives/language.html',
  link: (scope, element, attr) ->
    scope.notMe = Utils.notMe()
    scope.languageEditor = false

    scope.onLanguageEditor = ->
      scope.languageTemp = angular.copy(scope.language);
      scope.languageEditor = true;

    scope.onCancel = ->
      scope.languageEditor = false;

    scope.onSave = (valid, language) ->
      scope.language.language_id = scope.languageTemp.language_id if valid
      scope.language.level = scope.languageTemp.level if valid
      scope.languageEditor = !valid
      scope.updateLanguage(valid, language)
  }
angular
.module('gradshub-ng.directives')
.directive('language', Language)