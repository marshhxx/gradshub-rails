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

		if scope.data? and !scope.data.level?
			scope.level = "Select your level"
		else
			scope.level = scope.data.level

		scope.levels = ['Bigginer', 'Intermediate', 'Advanced']

		scope.languageSelected = (index) ->
			scope.level = scope.levels[index]
			scope.data.level = index

		scope.onLanguage = (language) ->
			scope.data.language_id = language.id if language?

	}
angular
	.module('mepedia.directives')
	.directive('languageForm', LanguageForm);