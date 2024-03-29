AddLanguage = (Utils) ->
  {
  scope: {
    saveLanguage: '=',
    language: '=data',
    onAdd: '=',
    onCancelClick: '=onCancel'
  },
  templateUrl: 'angular-app/templates/directives/add-language.html'
  link: (scope, element, attr) ->
    scope.notMe = Utils.notMe()

    scope.addLanguage = ->
      scope.language = {}
      scope.addLanguageEnable = true
      scope.onAdd()

    scope.onCancel = ->
      scope.addLanguageEnable = false
      scope.language = null
      scope.onCancelClick()

    scope.onSave = (valid) ->
      if valid
        scope.addLanguageEnable = false
        scope.onCancelClick()
        scope.saveLanguage(valid)


  }

angular
.module('gradshub-ng.directives')
.directive('addLanguage', AddLanguage)