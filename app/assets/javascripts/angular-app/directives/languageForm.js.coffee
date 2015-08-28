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

		if scope.data?
      scope.level = scope.data.level if scope.data.level?

		scope.levels = ['Begginer', 'Intermediate', 'Advanced']

		scope.onLevelSelect = () ->
			scope.data.level = scope.level

		scope.onLanguage = (language) ->
			scope.data.language_id = language.id if language?

	}
angular
	.module('mepedia.directives')
	.directive('languageForm', LanguageForm);