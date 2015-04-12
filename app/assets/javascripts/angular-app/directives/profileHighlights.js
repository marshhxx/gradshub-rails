angular.module('mepedia.directives').directive('profileHighlights', function () {
    return {
        scope: {
            user: '=data',
            userAge: '=',
            scrollTo: '='
        },
        templateUrl: 'angular-app/templates/directives/profileHighlights.html',
        link: function (scope, element, attrs) {

            scope.onExperienceEditor = function () {
                scope.scrollTo("focusExperience");
            }

            scope.onEducationEditor = function () {
                scope.scrollTo("focusEducation");
            }
        }
    };
});
