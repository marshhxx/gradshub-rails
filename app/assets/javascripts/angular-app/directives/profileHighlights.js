angular.module('mepedia.directives').directive('profileHighlights', function (click) {
    return {
        scope: {
            user: '='
        },
        templateUrl: 'angular-app/templates/directives/profile-highlights.html',
        link: function (scope, element, attrs) {

            scope.onExperienceEditor = function () {
                click("experienceEdit0");
            };

            scope.onEducationEditor = function () {
                click('educationEdit0');
            };
        }
    };
});
