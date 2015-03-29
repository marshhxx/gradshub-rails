angular.module('mepedia.directives').directive('experience', function () {
    return {
        scope: {
            experience: '=data', //Experience in experiences array
            updateExperience: '&',//Update experience
            experienceEditor: '='//Experience editor ng-show ng-hide variable
        },
        templateUrl: 'angular-app/templates/directives/experience.html',
        link: function (scope, element, attrs) {

            scope.experience.start_date = scope.experience.start_date.split('-')[0];
            scope.experience.end_date = scope.experience.end_date.split('-')[0];

            scope.onExperienceEditor = function () {
                getData();
                scope.experienceOriginal = angular.copy(scope.experience);
                scope.experienceEditor = true;
            };

            var getData = function () {
                /* Country.query(function (countries) {
                 scope.countries = countries.countries;
                 });*/
            }

            /* Methods */

            scope.onCancel = function () {
                scope.experienceEditor = false;
                scope.experience = scope.experienceOriginal;
            };

            scope.onStartYear = function (year) {
                scope.experience.start_date = year;
            };

            scope.onEndYear = function (year) {
                scope.experience.end_date = year;
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
