DegreeSelector = (Degree) ->
    {
    restrict: 'E',
    require: 'ngModel',
    scope: {
        onSelect: '='
        data: '=ngModel'
    },
    template: (elem, attr) ->
        required = if attr.required == "" then "required" else ""
        placeholder = if attr.placeholder then attr.placeholder else ""
        '<input name="degree" type="text" ng-model="data" ' + required + ' class="form-control" id="degree" placeholder="' + placeholder + '" ' +
            'typeahead="degree as degree.name for degree in degrees | filter:$viewValue | limitTo:6" class="form-control" typeahead-on-select="onSelect($item)" is-degree>'
    link: (scope, elm, attrs, ctrl) ->

        Degree.query (degrees) ->
            scope.degrees = degrees.degrees

    }
angular
    .module('mepedia.directives')
    .directive('degreeSelector', DegreeSelector)