angular.module('mepedia.directives').directive('addExperience', function () {
    return {
        scope: {
            experience: '=data', //Experience array
            saveExperience: '=', //SaveExperience function
            addExperienceEnable: '=' //Experience ng-show ng-hide variable
        },
        templateUrl: 'angular-app/templates/directives/addExperience.html',
        link: function (scope, element, attrs) {

            scope.addExperience = function () {
                scope.addExperienceEnable = true;
                clearAddExperienceValues();
                getData();
            };

            var clearAddExperienceValues = function () {
                scope.experience.company_name = "";
                scope.experience.job_title = "";
                scope.experience.description = "";
                scope.experience.start_date = "Start Year";
                scope.experience.end_date = "End Year";
            }

            var getData = function () {

                /* Company.query(function(countries) {
                 scope.countries = countries.countries;
                 });*/

            }

            /* Methods */

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

//            scope.onCompany = function (school) {
//                if (school != undefined)
//                    scope.education.school = school
//            };

            scope.onStartYear = function (year) {
                scope.experience.start_date = year;
            };

            scope.onEndYear = function (year) {
                scope.experience.end_date = year;
            };

            scope.onCancel = function () {
                scope.addExperienceEnable = false;
                scope.experience = [];
            };
        }
    };
});
