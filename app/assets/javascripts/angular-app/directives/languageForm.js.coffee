LanguageForm = (Language) ->
	{
	restrict: 'E',
	scope: {
		onCancel: '=',
		onSave: '=',
		data: '='
	},
	templateUrl: 'angular-app/templates/directives/language-form.html',
	link: (scope, $element) ->

		scope.onLanguage = (language) ->
			scope.data.language_id = language.id if language?

	}
angular
	.module('mepedia.directives')
	.directive('languageForm', LanguageForm);