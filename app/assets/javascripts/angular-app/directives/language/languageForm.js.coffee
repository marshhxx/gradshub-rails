LanguageForm = (Language) ->
  {
  restrict: 'E',
  scope: {
    onCancel: '=',
    onSave: '=',
    data: '=',
    editable: '=?'
    onDelete: '=?'
  },
  templateUrl: 'angular-app/templates/directives/language-form.html',
  link: (scope, $element) ->
    scope.level = scope.data.level if scope.data.level?

    scope.levels = ['Begginer', 'Intermediate', 'Advanced']

    scope.onLevelSelect = () ->
      scope.data.level = scope.level

    scope.onLanguage = (language) ->
      scope.data.language_id = language.id if language?

  }
angular
  .module('gradshub-ng.directives')
  .directive('languageForm', LanguageForm);