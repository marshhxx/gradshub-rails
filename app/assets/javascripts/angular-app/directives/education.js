angular.module('mepedia.directives').directive('education', ['State', 'Country', 'School', 'Major', 'Degree', function (State, Country, School, Major, Degree) {
    return {
        scope: {
            education: '=data',
            updateEducation: '&',
            educationEditor: '='
        },
        templateUrl: 'angular-app/templates/directives/education.html',
        link: function (scope, element, attrs) {

            scope.onEducationEditor = function () {
                getData();
                scope.educationTemp =  angular.copy(scope.education);
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
            };

            /* Methods */

            scope.onSave = function ($index) {
                scope.education.school = scope.educationTemp.school;
                scope.education.major = scope.educationTemp.major;
                scope.education.degree = scope.educationTemp.degree;
                scope.education.country = scope.educationTemp.country;
                scope.education.start_date = scope.educationTemp.start_date;
                scope.education.end_date = scope.educationTemp.end_date;
                scope.education.description = scope.educationTemp.description;
                scope.education.start_date = scope.educationTemp.start_date;
                scope.education.end_date = scope.educationTemp.end_date;
                scope.updateEducation($index);
            }

            scope.onCancel = function () {
                scope.educationEditor = false;
            };

            scope.getStateByCountryId = function (countryId) {
                State.query({country_id: countryId}, function (states) {
                    scope.states = states.states;
                });
            };

            scope.onSchool = function (school) {
                if (school != undefined)
                    scope.educationTemp.school = school
            };

            scope.onState = function (state) {
                if (state != undefined)
                    scope.educationTemp.state = state;
            };

            scope.onCountry = function (country) {
                scope.educationTemp.country = country
                if (scope.educationTemp.country != undefined)
                    scope.getStateByCountryId(scope.educationTemp.country.id);
            }

            scope.onMajor = function (major) {
                if (major != undefined)
                    scope.educationTemp.major = major
            };

            scope.onDegree = function (degree) {
                if (degree != undefined)
                    scope.educationTemp.degree = degree
            };
        }
    };
}]);
