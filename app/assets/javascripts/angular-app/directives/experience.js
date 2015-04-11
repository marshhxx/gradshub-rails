angular.module('mepedia.directives').directive('experience', function () {
    return {
        scope: {
            experience: '=data', //Experience in experiences array
            updateExperience: '&', //Update experience
            experienceEditor: '=', //Experience editor ng-show ng-hide variable
            defaultExperience: '=' //Default experience visibility
        },
        templateUrl: 'angular-app/templates/directives/experience.html',
        link: function (scope, element, attrs) {

            scope.onExperienceEditor = function () {
                if(scope.experience == undefined)
                    scope.defaultExperience = false;

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
                if(scope.experienceTemp == undefined)
                    scope.defaultExperience = true;
            };

            scope.onSave = function ($index) {
                scope.experience.company_name = scope.experienceTemp.company_name;
                scope.experience.job_title = scope.experienceTemp.job_title;
                scope.experience.start_date = scope.experienceTemp.start_date;
                scope.experience.end_date = scope.experienceTemp.end_date;
                scope.experience.description = scope.experienceTemp.description;
                scope.updateExperience($index);
            };

            scope.onStartYear = function (year) {
                scope.experienceTemp.start_date = year;
            };

            scope.onEndYear = function (year) {
                scope.experienceTemp.end_date = year;
            };

            scope.years = getYears();

            function getYears() {
                var first = 1950;
                var now = new Date();
                var second = now.getFullYear();
                var array = Array();

                for (var i = first; i <= second; i++) {
                    array.push(i);
                }
                return array.reverse();
            }
        }
    };
});
