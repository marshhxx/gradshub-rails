angular.module('mepedia.directives').directive('education', ['State', 'Country', 'School', 'Major', 'Degree', function (State, Country, School, Major, Degree) {
    return {
        scope: {
            education: '=data',
            updateEducation: '&'
        },
        templateUrl: 'angular-app/templates/directives/education.html',
        link: function (scope, element, attrs) {

            scope.education.start_date = scope.education.start_date.split('-')[0];
            scope.education.end_date = scope.education.end_date.split('-')[0];

            scope.onEducationEditor = function () {
                getData();
                scope.educationOriginal = angular.copy(scope.education);
                scope.educationEditor = true;
                scope.getStateByCountryId(scope.education.country.id);
            };

            var getData = function () {
                Country.query(function (countries) {
                    scope.countries = countries.countries;
                });

                School.get(function (schools) {
                    scope.schools = schools.schools;
                });

                Major.get(function (majors) {
                    scope.majors = majors.majors;
                });

                Degree.get(function (degrees) {
                    scope.degrees = degrees.degrees;
                });
            }

            /* Methods */

            scope.onCancel = function () {
                scope.educationEditor = false;
                scope.education = scope.educationOriginal;
            };

            scope.getStateByCountryId = function (countryId) {
                State.query({country_id: countryId}, function (states) {
                    scope.states = states.states;
                });
            };

            scope.onStartYear = function (year) {
                scope.education.start_date = year;
            };

            scope.onEndYear = function (year) {
                scope.education.end_date = year;
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

            scope.onSchool = function (school) {
                if (school != undefined)
                    scope.education.school = school
            };

            scope.onState = function (state) {
                if (state != undefined)
                    scope.education.state = state;
            };

            scope.onCountry = function (country) {
                scope.education.country = country
                if (scope.education.country != undefined)
                    scope.getStateByCountryId(scope.education.country.id);
            }

            scope.onMajor = function (major) {
                if (major != undefined)
                    scope.education.major = major
            };

            scope.onDegree = function (degree) {
                if (degree != undefined)
                    scope.education.degree = degree
            };
        }
    };
}]);
