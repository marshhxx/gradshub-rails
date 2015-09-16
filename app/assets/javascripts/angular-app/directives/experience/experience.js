angular.module('gradshub-ng.directives').directive('experience', [ 'Utils', function (Utils) {
    return {
        scope: {
            experience: '=data', //Experience in experiences array
            updateExperience: '=', //Update experience
            experienceEditor: '=', //Experience editor ng-show ng-hide variable
            onDelete: '='
        },
        templateUrl: 'angular-app/templates/directives/experience.html',
        link: function (scope, element, attrs) {

            scope.notMe = Utils.notMe();

            scope.onExperienceEditor = function () {
                scope.experienceTemp = angular.copy(scope.experience);
                scope.experienceEditor = true;
            };

            /* Methods */
            scope.onCancel = function () {
                scope.experienceEditor = false;
            };

            scope.onSave = function (valid, index) {
                if (valid) {
                    scope.experience.company_name = scope.experienceTemp.company_name;
                    scope.experience.job_title = scope.experienceTemp.job_title;
                    scope.experience.start_date = scope.experienceTemp.start_date;
                    scope.experience.end_date = scope.experienceTemp.end_date;
                    scope.experience.description = scope.experienceTemp.description;
                    scope.experience.start_date = scope.experienceTemp.start_date;
                    if (scope.isCurrentJob)
                        scope.experienceTemp.end_date = undefined;
                    scope.experience.end_date = scope.experienceTemp.end_date;
                    
                }
                scope.updateExperience(valid, index);
            };

            scope.getMonth = Utils.getMonthByNumber;

            scope.experience.end_date ? scope.isCurrentJob = false : scope.isCurrentJob = true;

            scope.$watchGroup(['experienceTemp.start_date', 'experienceTemp.end_date'], function () {
                if (scope.experienceTemp) {
                    var valid = Date.parse(scope.experienceTemp.end_date) >= Date.parse(scope.experienceTemp.start_date);
                    valid = scope.experienceTemp.end_date == null || valid;
                    scope.experienceForm.$setValidity('validDates', valid)
                }
            });
        }
    };
}]);
