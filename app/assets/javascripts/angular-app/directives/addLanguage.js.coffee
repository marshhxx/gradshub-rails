AddLanguage = () ->
	{
		scope: {
			saveLanguage: '=',
			language: '=data',
			onAdd: '=',
			onCancelClick: '=onCancel'
		},
		templateUrl: 'angular-app/templates/directives/add-language.html'
		link: (scope, element, attr) ->

			scope.addLanguage = ->
				scope.language = {}
				scope.addLanguageEnable = true
				scope.onAdd()

			scope.onCancel = ->
				scope.addLanguageEnable = false
				scope.language = null
				scope.onCancelClick()

			scope.onSave = (valid) ->
				scope.addLanguageEnable = false
				scope.saveLanguage(valid)


	}

angular
	.module('mepedia.directives')
	.directive('addLanguage', AddLanguage)