Language = () ->
	{
		scope: {
			language: '=data',
			updateLanguage: '=',
			onDelete: '='
		},
		templateUrl: 'angular-app/templates/directives/language.html',
		link: (scope, element, attr) ->
			scope.languageEditor = false

			scope.onLanguageEditor = ->
				scope.languageTemp = angular.copy(scope.language);
				scope.languageEditor = true;

			scope.onCancel = ->
				scope.languageEditor = false;

			scope.onSave = (valid, index) ->
				scope.language.language_id = scope.languageTemp.language_id
				scope.language.level = scope.languageTemp.level
				scope.updateLanguage(valid, index)
	}
angular
	.module('mepedia.directives')
	.directive('language', Language)