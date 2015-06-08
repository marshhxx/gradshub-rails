LanguageSelector = (Language) ->
	{
	restrict: 'E',
	require: 'ngModel',
	scope: {
		onSelect: '=',
		data: '=ngModel',
	},
	template: (elem, attr) ->
		required = if attr.required == "" then "required" else ""
		placeholder = if attr.placeholder then attr.placeholder else ""
		'<input typeahead-editable="false" name="language" type="text" ng-model="data" ' + required + ' class="form-control input-sm align-vertical" id="degree" placeholder="' + placeholder + '" ' +
			'typeahead="language as language.name for language in languages | filter:$viewValue | limitTo:6" class="form-control" typeahead-on-select="onSelect($item)">'
	link: (scope, elm, attrs, ctrl) ->

    scope.onSelect = (language) ->
      scope.onSelectCallback(languageNameMap[language]) if language of languageNameMap

    Language.query (languages) ->
      scope.languages = languages.languages.map (language) -> language.name
      for language in languages.languages
        languageNameMap[language.name] = language

  }
angular
.module('mepedia.directives')
.directive('languageSelector', LanguageSelector)