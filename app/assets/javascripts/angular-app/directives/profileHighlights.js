angular.module('mepedia.directives').directive('profileHighlights', function (click, Utils) {
    return {
        scope: {
            user: '='
        },
        templateUrl: 'angular-app/templates/directives/profile-highlights.html',
        link: function (scope, element, attrs) {
            scope.notMe = Utils.notMe();

            scope.onExperienceEditor = function () {
                click("experienceEdit0");
            };

            scope.onEducationEditor = function () {
                click('educationEdit0');
            };
        }
    };
});
