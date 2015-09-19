Highlights = function (click, Utils) {
    return {
        scope: {
            user: '='
        },
        templateUrl: 'angular-app/templates/directives/profile-highlights.html',
        link: function (scope, element, attrs) {
            scope.notMe = Utils.notMe();

            scope.onExperienceEditor = function () {
                if (user.experiences.length != 0) {
                    click("experienceEdit0");
                } else {
                    click('addExperience');
                }
            };

            scope.onEducationEditor = function () {
                if (user.education.length != 0) {
                    click('educationEdit0');
                } else {
                    click('addEducation');
                }
            };
        }
    };
};
angular.module('gradshub-ng.directives').directive('profileHighlights', Highlights)
