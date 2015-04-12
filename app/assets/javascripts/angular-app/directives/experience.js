angular.module('mepedia.directives').directive('experience', [ 'Utils', function (Utils) {
    return {
        scope: {
            experience: '=data', //Experience in experiences array
            updateExperience: '&', //Update experience
            experienceEditor: '=' //Experience editor ng-show ng-hide variable
        },
        templateUrl: 'angular-app/templates/directives/experience.html',
        link: function (scope, element, attrs) {

            scope.onExperienceEditor = function () {
                scope.experienceTemp = angular.copy(scope.experience);
                scope.experienceEditor = true;
                scope.experienceTemp.start_date = scope.experience.start_date.split('-')[0];
                scope.experienceTemp.end_date = scope.experience.end_date.split('-')[0];
            };

            var getData = function () {
                /* Country.query(function (countries) {
                 scope.countries = countries.countries;
                 });*/
            }

            /* Methods */
            scope.onCancel = function () {
                scope.experienceEditor = false;
            };

            scope.onSave = function ($index) {
                scope.experience.company_name = scope.experienceTemp.company_name;
                scope.experience.job_title = scope.experienceTemp.job_title;
                scope.experience.start_date = scope.experienceTemp.start_date;
                scope.experience.end_date = scope.experienceTemp.end_date;
                scope.experience.description = scope.experienceTemp.description;
                scope.updateExperience($index);
            };

            scope.getMonth = function(month) {
                return Utils.getMonth(month);
            }
        }
    };
}]);
